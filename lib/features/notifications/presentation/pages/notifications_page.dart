import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final allNotifications = ref.watch(notificationProvider);

    final unreadCount = allNotifications
        .where((notification) => !notification.isRead)
        .length;

    final notifications = switch (_filter) {
      'Unread' =>
        allNotifications.where((notification) => !notification.isRead).toList(),
      'Read' =>
        allNotifications.where((notification) => notification.isRead).toList(),
      _ => allNotifications,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Infrastructure activity',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.read(notificationProvider.notifier).resetNotifications();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications refreshed.')),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            tooltip: 'Notification actions',
            onSelected: (value) {
              if (value == 'read-all') {
                ref.read(notificationProvider.notifier).markAllAsRead();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read.'),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'read-all',
                child: Row(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notification Center',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Review alerts, monitoring events, and system activity.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      if (unreadCount > 0)
                        Badge(
                          label: Text('$unreadCount'),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 28,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Unread', 'Read'].map((filter) {
                      return FilterChip(
                        label: Text(filter),
                        selected: _filter == filter,
                        onSelected: (_) {
                          setState(() {
                            _filter = filter;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        '${notifications.length} notifications',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '$unreadCount unread',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (notifications.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...notifications.map(
                      (notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _NotificationCard(
                          notification: notification,
                          onTap: () {
                            if (!notification.isRead) {
                              ref
                                  .read(notificationProvider.notifier)
                                  .markAsRead(notification.id);
                            }
                          },
                          onToggleRead: () {
                            if (notification.isRead) {
                              ref
                                  .read(notificationProvider.notifier)
                                  .markAsUnread(notification.id);
                            } else {
                              ref
                                  .read(notificationProvider.notifier)
                                  .markAsRead(notification.id);
                            }
                          },
                          onDelete: () {
                            ref
                                .read(notificationProvider.notifier)
                                .removeNotification(notification.id);
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      'Development notifications — backend service not connected',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 14),
          Text(
            'No $_filter notifications',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'There are currently no notifications matching this filter.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onToggleRead,
    required this.onDelete,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(child: Icon(_iconForType(notification.type))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.circle, size: 9),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(notification.message),
                    const SizedBox(height: 8),
                    Text(
                      notification.createdAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Notification options',
                onSelected: (value) {
                  switch (value) {
                    case 'toggle-read':
                      onToggleRead();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'toggle-read',
                    child: Text(
                      notification.isRead ? 'Mark as unread' : 'Mark as read',
                    ),
                  ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return Icons.warning_amber_outlined;
      case NotificationType.project:
        return Icons.folder_outlined;
      case NotificationType.monitoring:
        return Icons.monitor_heart_outlined;
      case NotificationType.system:
        return Icons.settings_outlined;
      case NotificationType.ai:
        return Icons.auto_awesome_outlined;
    }
  }
}

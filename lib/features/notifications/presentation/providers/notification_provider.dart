import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';

class NotificationNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    return const [
      NotificationModel(
        id: '1',
        title: 'Critical CPU Alert',
        message:
            'CPU utilization exceeded the configured threshold on Production API.',
        type: NotificationType.alert,
        createdAt: '5 min ago',
      ),
      NotificationModel(
        id: '2',
        title: 'Memory Usage Warning',
        message: 'Worker Service memory utilization has remained above 80%.',
        type: NotificationType.monitoring,
        createdAt: '18 min ago',
      ),
      NotificationModel(
        id: '3',
        title: 'Project Added',
        message: 'Web Application has been added to infrastructure monitoring.',
        type: NotificationType.project,
        createdAt: '1 hour ago',
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'AI Analysis Completed',
        message:
            'DevWatch AI completed infrastructure risk analysis and generated recommendations.',
        type: NotificationType.ai,
        createdAt: '2 hours ago',
      ),
      NotificationModel(
        id: '5',
        title: 'System Health Updated',
        message:
            'Infrastructure health information has been refreshed successfully.',
        type: NotificationType.system,
        createdAt: '3 hours ago',
        isRead: true,
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  void markAsUnread(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: false)
        else
          notification,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state) notification.copyWith(isRead: true),
    ];
  }

  void removeNotification(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  void resetNotifications() {
    ref.invalidateSelf();
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, List<NotificationModel>>(
      NotificationNotifier.new,
    );

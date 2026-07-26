import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/alert_model.dart';
import '../providers/alert_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_summary_card.dart';

class AlertsPage extends ConsumerStatefulWidget {
  const AlertsPage({super.key});

  @override
  ConsumerState<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ConsumerState<AlertsPage> {
  String _filter = 'All';

  void _showDetails(AlertModel alert) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: Theme.of(sheetContext).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Text(alert.description),

                  const SizedBox(height: 20),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dns_outlined),
                    title: const Text('Source'),
                    subtitle: Text(alert.source),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule),
                    title: const Text('Triggered'),
                    subtitle: Text(alert.triggeredAt),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: const Text('Severity'),
                    subtitle: Text(_severityLabel(alert.severity)),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Status'),
                    subtitle: Text(_statusLabel(alert.status)),
                  ),

                  const SizedBox(height: 16),

                  if (alert.status == AlertStatus.active) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref
                              .read(alertProvider.notifier)
                              .acknowledgeAlert(alert.id);

                          Navigator.of(sheetContext).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${alert.title} acknowledged.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Acknowledge'),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  if (alert.status != AlertStatus.resolved) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          ref
                              .read(alertProvider.notifier)
                              .resolveAlert(alert.id);

                          Navigator.of(sheetContext).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${alert.title} resolved.')),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Resolve Alert'),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _severityLabel(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.medium:
        return 'Medium';
      case AlertSeverity.low:
        return 'Low';
    }
  }

  String _statusLabel(AlertStatus status) {
    switch (status) {
      case AlertStatus.active:
        return 'Active';
      case AlertStatus.acknowledged:
        return 'Acknowledged';
      case AlertStatus.resolved:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAlerts = ref.watch(alertProvider);

    final alerts = switch (_filter) {
      'Active' =>
        allAlerts.where((alert) => alert.status == AlertStatus.active).toList(),
      'Acknowledged' =>
        allAlerts
            .where((alert) => alert.status == AlertStatus.acknowledged)
            .toList(),
      'Resolved' =>
        allAlerts
            .where((alert) => alert.status == AlertStatus.resolved)
            .toList(),
      _ => allAlerts,
    };

    final activeCount = allAlerts
        .where((alert) => alert.status == AlertStatus.active)
        .length;

    final acknowledgedCount = allAlerts
        .where((alert) => alert.status == AlertStatus.acknowledged)
        .length;

    final resolvedCount = allAlerts
        .where((alert) => alert.status == AlertStatus.resolved)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Incidents and notifications',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.read(alertProvider.notifier).resetAlerts();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alerts refreshed.')),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alert Center',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'Review infrastructure incidents and system warnings.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 800 ? 4 : 2;

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 4 ? 1.7 : 1.5,
                        children: [
                          AlertSummaryCard(
                            title: 'Total Alerts',
                            value: '${allAlerts.length}',
                            icon: Icons.notifications_outlined,
                          ),
                          AlertSummaryCard(
                            title: 'Active',
                            value: '$activeCount',
                            icon: Icons.error_outline,
                          ),
                          AlertSummaryCard(
                            title: 'Acknowledged',
                            value: '$acknowledgedCount',
                            icon: Icons.visibility_outlined,
                          ),
                          AlertSummaryCard(
                            title: 'Resolved',
                            value: '$resolvedCount',
                            icon: Icons.check_circle_outline,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Active', 'Acknowledged', 'Resolved']
                          .map((filter) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: _filter == filter,
                                onSelected: (_) {
                                  setState(() {
                                    _filter = filter;
                                  });
                                },
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        '${alerts.length} alerts',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        'Filter: $_filter',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (alerts.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...alerts.map(
                      (alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AlertCard(
                          alert: alert,
                          onTap: () => _showDetails(alert),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Development alerts — backend alert engine not connected',
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
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No $_filter alerts',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'There are currently no alerts matching this filter.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

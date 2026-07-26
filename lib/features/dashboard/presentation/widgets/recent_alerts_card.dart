import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/data/models/alert_model.dart';
import '../../../alerts/presentation/providers/alert_provider.dart';

class RecentAlertsCard extends ConsumerWidget {
  const RecentAlertsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAlerts = ref.watch(alertProvider);

    final alerts = allAlerts
        .where((alert) => alert.status != AlertStatus.resolved)
        .take(3)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent Alerts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/alerts'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (alerts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 42),
                      SizedBox(height: 10),
                      Text('No active alerts'),
                    ],
                  ),
                ),
              )
            else
              ...alerts.map(
                (alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AlertItem(alert: alert),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_severityIcon(alert.severity), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(alert.source, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                alert.triggeredAt,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _statusLabel(alert.status),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  IconData _severityIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error_outline;
      case AlertSeverity.high:
        return Icons.warning_amber_outlined;
      case AlertSeverity.medium:
        return Icons.info_outline;
      case AlertSeverity.low:
        return Icons.notifications_none;
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
}

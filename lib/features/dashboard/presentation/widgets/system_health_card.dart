import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../alerts/data/models/alert_model.dart';
import '../../../alerts/presentation/providers/alert_provider.dart';
import '../../../monitoring/presentation/providers/monitoring_provider.dart';
import '../../../projects/presentation/providers/project_provider.dart';

class SystemHealthCard extends ConsumerWidget {
  const SystemHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertProvider);
    final projectState = ref.watch(projectProvider);
    final projects = projectState.projects;
    final metrics = ref.watch(monitoringProvider);

    final activeAlerts = alerts
        .where((alert) => alert.status == AlertStatus.active)
        .length;

    final criticalAlerts = alerts
        .where(
          (alert) =>
              alert.status == AlertStatus.active &&
              alert.severity == AlertSeverity.critical,
        )
        .length;

    final operationalProjects = projects
        .where((project) => project.status == 'Operational')
        .length;

    final warningMetrics = metrics
        .where((metric) => metric.status == 'Warning')
        .length;

    final HealthState health;

    if (criticalAlerts > 0) {
      health = const HealthState(
        title: 'Critical Attention Required',
        description: 'Critical infrastructure incidents require attention.',
        icon: Icons.error_outline,
      );
    } else if (activeAlerts > 0 || warningMetrics > 0) {
      health = const HealthState(
        title: 'System Requires Attention',
        description: 'Some infrastructure resources require review.',
        icon: Icons.warning_amber_outlined,
      );
    } else if (projectState.errorMessage != null) {
      health = const HealthState(
        title: 'Project Data Unavailable',
        description:
            'DevWatch could not retrieve the latest project information.',
        icon: Icons.cloud_off_outlined,
      );
    } else {
      health = const HealthState(
        title: 'All Systems Operational',
        description: 'No active infrastructure incidents detected.',
        icon: Icons.check_circle_outline,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(health.icon, size: 42),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    health.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(health.description),

                  const SizedBox(height: 14),

                  if (projectState.isLoading && projects.isEmpty)
                    const LinearProgressIndicator()
                  else
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        _HealthDetail(
                          label: 'Projects',
                          value: '${projects.length}',
                        ),
                        _HealthDetail(
                          label: 'Operational',
                          value: '$operationalProjects',
                        ),
                        _HealthDetail(
                          label: 'Active Alerts',
                          value: '$activeAlerts',
                        ),
                        _HealthDetail(
                          label: 'Metric Warnings',
                          value: '$warningMetrics',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthState {
  const HealthState({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _HealthDetail extends StatelessWidget {
  const _HealthDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

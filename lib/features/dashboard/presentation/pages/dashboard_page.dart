import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/data/models/alert_model.dart';
import '../../../alerts/presentation/providers/alert_provider.dart';
import '../../../monitoring/data/models/monitoring_metric.dart';
import '../../../monitoring/presentation/providers/monitoring_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../projects/presentation/providers/project_provider.dart';

import '../widgets/metric_card.dart';
import '../widgets/project_status_card.dart';
import '../widgets/recent_alerts_card.dart';
import '../widgets/system_health_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch shared application state.
    final monitoringMetrics = ref.watch(monitoringProvider);
    final alerts = ref.watch(alertProvider);
    final projects = ref.watch(projectProvider);
    final notifications = ref.watch(notificationProvider);

    // Monitoring metrics.
    final cpu = _findMetric(monitoringMetrics, 'cpu');
    final memory = _findMetric(monitoringMetrics, 'memory');
    final response = _findMetric(monitoringMetrics, 'response');

    // Alert information.
    final activeAlerts = alerts
        .where((alert) => alert.status == AlertStatus.active)
        .length;

    final hasCriticalAlert = alerts.any(
      (alert) =>
          alert.status == AlertStatus.active &&
          alert.severity == AlertSeverity.critical,
    );

    // Project information.
    final operationalProjects = projects
        .where((project) => project.status == 'Operational')
        .length;

    // Notification information.
    final unreadNotifications = notifications
        .where((notification) => !notification.isRead)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DevWatch', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Infrastructure Overview',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          // Notifications.
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.go('/notifications'),
            icon: Badge(
              isLabelVisible: unreadNotifications > 0,
              label: Text('$unreadNotifications'),
              child: const Icon(Icons.notifications_none),
            ),
          ),

          const SizedBox(width: 4),

          // Logout.
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Monitor infrastructure health and system performance.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  // Overall system health.
                  const SystemHealthCard(),

                  const SizedBox(height: 20),

                  // Infrastructure metrics.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns;

                      if (constraints.maxWidth >= 1100) {
                        columns = 4;
                      } else if (constraints.maxWidth >= 650) {
                        columns = 2;
                      } else {
                        columns = 1;
                      }

                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: columns == 1 ? 1.8 : 1.25,
                        children: [
                          MetricCard(
                            title: 'CPU Usage',
                            value: cpu == null
                                ? '--'
                                : '${cpu.value}${cpu.unit}',
                            subtitle: cpu?.description ?? 'No CPU data',
                            icon: Icons.memory,
                            progress: cpu?.progress ?? 0,
                          ),

                          MetricCard(
                            title: 'Memory',
                            value: memory == null
                                ? '--'
                                : '${memory.value}${memory.unit}',
                            subtitle: memory?.description ?? 'No memory data',
                            icon: Icons.storage_outlined,
                            progress: memory?.progress ?? 0,
                          ),

                          MetricCard(
                            title: 'Projects',
                            value: '${projects.length}',
                            subtitle:
                                '$operationalProjects operational projects',
                            icon: Icons.cloud_done_outlined,
                            progress: projects.isEmpty
                                ? 0
                                : operationalProjects / projects.length,
                          ),

                          MetricCard(
                            title: 'Response',
                            value: response == null
                                ? '--'
                                : '${response.value} ${response.unit}',
                            subtitle:
                                response?.description ??
                                'No response-time data',
                            icon: Icons.speed,
                            progress: response?.progress ?? 0,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Active alert banner.
                  _buildAlertBanner(
                    context,
                    activeAlerts: activeAlerts,
                    hasCriticalAlert: hasCriticalAlert,
                  ),

                  const SizedBox(height: 20),

                  // Alerts and project status.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 900) {
                        return const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: RecentAlertsCard()),
                            SizedBox(width: 16),
                            Expanded(child: ProjectStatusCard()),
                          ],
                        );
                      }

                      return const Column(
                        children: [
                          RecentAlertsCard(),
                          SizedBox(height: 16),
                          ProjectStatusCard(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      'Development data — backend monitoring not connected',
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

  MonitoringMetric? _findMetric(List<MonitoringMetric> metrics, String id) {
    for (final metric in metrics) {
      if (metric.id == id) {
        return metric;
      }
    }

    return null;
  }

  Widget _buildAlertBanner(
    BuildContext context, {
    required int activeAlerts,
    required bool hasCriticalAlert,
  }) {
    if (activeAlerts == 0) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: const Text('No active alerts'),
          subtitle: const Text(
            'No active infrastructure incidents require attention.',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/alerts'),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: Icon(
          hasCriticalAlert ? Icons.error_outline : Icons.warning_amber_outlined,
        ),
        title: Text(
          '$activeAlerts active ${activeAlerts == 1 ? 'alert' : 'alerts'}',
        ),
        subtitle: Text(
          hasCriticalAlert
              ? 'Critical infrastructure alerts require attention.'
              : 'Infrastructure alerts require review.',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/alerts'),
      ),
    );
  }
}

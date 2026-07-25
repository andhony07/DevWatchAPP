import 'package:flutter/material.dart';

import '../../data/models/alert_model.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_summary_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String _filter = 'All';

  static const _alerts = [
    AlertModel(
      id: '1',
      title: 'High CPU Usage',
      description: 'CPU utilization exceeded the configured 85% threshold.',
      source: 'Production API',
      severity: AlertSeverity.critical,
      status: AlertStatus.active,
      triggeredAt: '5 min ago',
    ),
    AlertModel(
      id: '2',
      title: 'Memory Threshold Reached',
      description: 'Memory utilization has remained above 80%.',
      source: 'Worker Service',
      severity: AlertSeverity.high,
      status: AlertStatus.acknowledged,
      triggeredAt: '18 min ago',
    ),
    AlertModel(
      id: '3',
      title: 'Response Time Increased',
      description: 'Average API response time increased above 300 ms.',
      source: 'API Gateway',
      severity: AlertSeverity.medium,
      status: AlertStatus.active,
      triggeredAt: '42 min ago',
    ),
    AlertModel(
      id: '4',
      title: 'Database Connection Recovered',
      description: 'Database connectivity returned to normal.',
      source: 'Database',
      severity: AlertSeverity.low,
      status: AlertStatus.resolved,
      triggeredAt: '2 hours ago',
    ),
  ];

  List<AlertModel> get _filteredAlerts {
    switch (_filter) {
      case 'Active':
        return _alerts
            .where((alert) => alert.status == AlertStatus.active)
            .toList();

      case 'Acknowledged':
        return _alerts
            .where((alert) => alert.status == AlertStatus.acknowledged)
            .toList();

      case 'Resolved':
        return _alerts
            .where((alert) => alert.status == AlertStatus.resolved)
            .toList();

      default:
        return _alerts;
    }
  }

  void _showDetails(AlertModel alert) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _filteredAlerts;

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
            onPressed: () {},
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
                        children: const [
                          AlertSummaryCard(
                            title: 'Total Alerts',
                            value: '4',
                            icon: Icons.notifications_outlined,
                          ),
                          AlertSummaryCard(
                            title: 'Active',
                            value: '2',
                            icon: Icons.error_outline,
                          ),
                          AlertSummaryCard(
                            title: 'Acknowledged',
                            value: '1',
                            icon: Icons.visibility_outlined,
                          ),
                          AlertSummaryCard(
                            title: 'Resolved',
                            value: '1',
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

                  Text(
                    '${alerts.length} alerts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

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
}

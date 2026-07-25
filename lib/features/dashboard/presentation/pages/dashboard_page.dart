import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/metric_card.dart';
import '../widgets/project_status_card.dart';
import '../widgets/recent_alerts_card.dart';
import '../widgets/system_health_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Badge(child: Icon(Icons.notifications_none)),
          ),
          const SizedBox(width: 4),
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
                  const SystemHealthCard(),
                  const SizedBox(height: 20),
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
                        children: const [
                          MetricCard(
                            title: 'CPU Usage',
                            value: '42%',
                            subtitle: 'Average utilization',
                            icon: Icons.memory,
                            progress: 0.42,
                          ),
                          MetricCard(
                            title: 'Memory',
                            value: '68%',
                            subtitle: '10.9 GB / 16 GB',
                            icon: Icons.storage_outlined,
                            progress: 0.68,
                          ),
                          MetricCard(
                            title: 'Availability',
                            value: '99.98%',
                            subtitle: 'Last 30 days',
                            icon: Icons.cloud_done_outlined,
                            progress: 0.9998,
                          ),
                          MetricCard(
                            title: 'Response',
                            value: '124 ms',
                            subtitle: 'Average response time',
                            icon: Icons.speed,
                            progress: 0.31,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
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
}

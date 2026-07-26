import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/monitoring_provider.dart';
import '../widgets/monitoring_metric_card.dart';
import '../widgets/performance_overview.dart';
import '../widgets/service_health_card.dart';

class MonitoringPage extends ConsumerWidget {
  const MonitoringPage({super.key});

  static const _icons = [
    Icons.memory,
    Icons.storage_outlined,
    Icons.sd_storage_outlined,
    Icons.network_check,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(monitoringProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monitoring', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Infrastructure metrics',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.read(monitoringProvider.notifier).resetMetrics();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Monitoring metrics refreshed.')),
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
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Infrastructure Overview',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Monitor system resources and service performance.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Monitoring metric cards
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

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: metrics.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: columns == 1 ? 1.7 : 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final metric = metrics[index];

                          final icon = index < _icons.length
                              ? _icons[index]
                              : Icons.monitor_heart_outlined;

                          return MonitoringMetricCard(
                            metric: metric,
                            icon: icon,
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Service health and performance
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 900) {
                        return const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: ServiceHealthCard()),
                            SizedBox(width: 16),
                            Expanded(child: PerformanceOverview()),
                          ],
                        );
                      }

                      return const Column(
                        children: [
                          ServiceHealthCard(),
                          SizedBox(height: 16),
                          PerformanceOverview(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      'Development metrics — live monitoring not connected',
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

import 'package:flutter/material.dart';

import '../../data/models/monitoring_metric.dart';
import '../widgets/monitoring_metric_card.dart';
import '../widgets/performance_overview.dart';
import '../widgets/service_health_card.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  static const _metrics = [
    MonitoringMetric(
      name: 'CPU Usage',
      value: '42',
      unit: '%',
      progress: 0.42,
      description: 'Average CPU utilization',
    ),
    MonitoringMetric(
      name: 'Memory',
      value: '68',
      unit: '%',
      progress: 0.68,
      description: '10.9 GB of 16 GB',
    ),
    MonitoringMetric(
      name: 'Disk Usage',
      value: '54',
      unit: '%',
      progress: 0.54,
      description: '216 GB of 400 GB',
    ),
    MonitoringMetric(
      name: 'Network',
      value: '42.8',
      unit: 'MB/s',
      progress: 0.43,
      description: 'Current network throughput',
    ),
  ];

  static const _icons = [
    Icons.memory,
    Icons.storage_outlined,
    Icons.sd_storage_outlined,
    Icons.network_check,
  ];

  @override
  Widget build(BuildContext context) {
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
                        itemCount: _metrics.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: columns == 1 ? 1.7 : 1.2,
                        ),
                        itemBuilder: (context, index) {
                          return MonitoringMetricCard(
                            metric: _metrics[index],
                            icon: _icons[index],
                          );
                        },
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

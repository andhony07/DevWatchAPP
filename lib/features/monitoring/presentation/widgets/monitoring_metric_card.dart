import 'package:flutter/material.dart';

import '../../data/models/monitoring_metric.dart';

class MonitoringMetricCard extends StatelessWidget {
  const MonitoringMetricCard({
    required this.metric,
    required this.icon,
    super.key,
  });

  final MonitoringMetric metric;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.onPrimaryContainer),
                ),
                const Spacer(),
                Text(
                  metric.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  metric.value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(metric.unit),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              metric.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            LinearProgressIndicator(
              value: metric.progress,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}

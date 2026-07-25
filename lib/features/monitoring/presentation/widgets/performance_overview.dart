import 'package:flutter/material.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Infrastructure performance summary',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            const _PerformanceRow(
              label: 'Availability',
              value: '99.98%',
              icon: Icons.cloud_done_outlined,
            ),
            const Divider(),
            const _PerformanceRow(
              label: 'Average Response Time',
              value: '124 ms',
              icon: Icons.speed_outlined,
            ),
            const Divider(),
            const _PerformanceRow(
              label: 'Error Rate',
              value: '0.18%',
              icon: Icons.error_outline,
            ),
            const Divider(),
            const _PerformanceRow(
              label: 'Network Traffic',
              value: '42.8 MB/s',
              icon: Icons.swap_vert,
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

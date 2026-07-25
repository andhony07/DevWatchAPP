import 'package:flutter/material.dart';

class RecentAlertsCard extends StatelessWidget {
  const RecentAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Alerts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('View all')),
              ],
            ),
            const Divider(),
            const _AlertItem(
              title: 'High CPU Usage',
              source: 'Production API',
              time: '5 min ago',
              icon: Icons.warning_amber,
            ),
            const Divider(),
            const _AlertItem(
              title: 'Memory threshold reached',
              source: 'Worker Service',
              time: '18 min ago',
              icon: Icons.memory,
            ),
            const Divider(),
            const _AlertItem(
              title: 'Response time increased',
              source: 'Gateway',
              time: '42 min ago',
              icon: Icons.speed,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({
    required this.title,
    required this.source,
    required this.time,
    required this.icon,
  });

  final String title;
  final String source;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(source, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(time, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AnalysisHistoryCard extends StatelessWidget {
  const AnalysisHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis History',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Recent AI infrastructure assessments',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const _HistoryItem(
              title: 'Production API Analysis',
              risk: 'Moderate',
              time: '10 min ago',
            ),
            const Divider(),
            const _HistoryItem(
              title: 'Worker Service Analysis',
              risk: 'High',
              time: 'Yesterday',
            ),
            const Divider(),
            const _HistoryItem(
              title: 'Web Application Analysis',
              risk: 'Low',
              time: '2 days ago',
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.title,
    required this.risk,
    required this.time,
  });

  final String title;
  final String risk;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.history),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(time, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(risk, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

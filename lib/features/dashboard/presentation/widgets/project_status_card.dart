import 'package:flutter/material.dart';

class ProjectStatusCard extends StatelessWidget {
  const ProjectStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const _ProjectItem(
              name: 'Production API',
              environment: 'Production',
              status: 'Operational',
            ),
            const Divider(),
            const _ProjectItem(
              name: 'Web Application',
              environment: 'Production',
              status: 'Operational',
            ),
            const Divider(),
            const _ProjectItem(
              name: 'Worker Service',
              environment: 'Staging',
              status: 'Warning',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  const _ProjectItem({
    required this.name,
    required this.environment,
    required this.status,
  });

  final String name;
  final String environment;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.cloud_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(environment, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(status),
        ],
      ),
    );
  }
}

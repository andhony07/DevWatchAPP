import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../projects/presentation/providers/project_provider.dart';

class ProjectStatusCard extends ConsumerWidget {
  const ProjectStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final projects = projectState.projects;

    final operational = projects
        .where((project) => project.status == 'Operational')
        .length;

    final warning = projects
        .where((project) => project.status == 'Warning')
        .length;

    final other = projects.length - operational - warning;

    final operationalProgress = projects.isEmpty
        ? 0.0
        : operational / projects.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Project Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/projects'),
                  child: const Text('View All'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (projectState.isLoading && projects.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _StatusItem(
                      title: 'Total',
                      value: '${projects.length}',
                      icon: Icons.folder_outlined,
                    ),
                  ),
                  Expanded(
                    child: _StatusItem(
                      title: 'Operational',
                      value: '$operational',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _StatusItem(
                      title: 'Warning',
                      value: '$warning',
                      icon: Icons.warning_amber_outlined,
                    ),
                  ),
                  Expanded(
                    child: _StatusItem(
                      title: 'Other',
                      value: '$other',
                      icon: Icons.info_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Operational projects',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(value: operationalProgress),

              const SizedBox(height: 8),

              Text(
                projects.isEmpty
                    ? 'No projects configured'
                    : '$operational of ${projects.length} operational',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              if (projectState.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Project data unavailable',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

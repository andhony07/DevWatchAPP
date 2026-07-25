import 'package:flutter/material.dart';

import '../../data/models/project_model.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const _projects = [
    ProjectModel(
      id: '1',
      name: 'Production API',
      description: 'Primary backend API serving production traffic.',
      environment: 'Production',
      cloudProvider: 'AWS',
      status: 'Operational',
      repositoryUrl: 'https://example.com/production-api',
    ),
    ProjectModel(
      id: '2',
      name: 'Web Application',
      description: 'Customer-facing application deployment.',
      environment: 'Production',
      cloudProvider: 'Google Cloud',
      status: 'Operational',
      repositoryUrl: 'https://example.com/web-app',
    ),
    ProjectModel(
      id: '3',
      name: 'Worker Service',
      description: 'Background jobs and asynchronous processing.',
      environment: 'Staging',
      cloudProvider: 'Azure',
      status: 'Warning',
      repositoryUrl: 'https://example.com/worker-service',
    ),
  ];

  void _showAddProject(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProject(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitored Projects',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage applications and infrastructure monitored by DevWatch.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns;

                      if (constraints.maxWidth >= 1200) {
                        columns = 3;
                      } else if (constraints.maxWidth >= 700) {
                        columns = 2;
                      } else {
                        columns = 1;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _projects.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: columns == 1 ? 1.25 : 1.05,
                        ),
                        itemBuilder: (context, index) {
                          final project = _projects[index];

                          return ProjectCard(
                            project: project,
                            onOpen: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${project.name} details will be implemented next.',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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

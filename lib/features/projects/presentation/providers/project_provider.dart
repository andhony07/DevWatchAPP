import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/project_model.dart';

class ProjectNotifier extends Notifier<List<ProjectModel>> {
  @override
  List<ProjectModel> build() {
    return const [
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
  }

  void addProject(ProjectModel project) {
    state = [...state, project];
  }

  void removeProject(String id) {
    state = state.where((project) => project.id != id).toList();
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, List<ProjectModel>>(
  ProjectNotifier.new,
);

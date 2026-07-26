import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectState {
  const ProjectState({
    this.projects = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.errorMessage,
  });

  final List<ProjectModel> projects;
  final bool isLoading;
  final bool isCreating;
  final String? errorMessage;

  ProjectState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    bool? isCreating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl();
});

class ProjectNotifier extends Notifier<ProjectState> {
  ProjectRepository get _repository {
    return ref.read(projectRepositoryProvider);
  }

  @override
  ProjectState build() {
    return const ProjectState();
  }

  Future<void> loadProjects() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final projects = await _repository.getProjects();

      state = ProjectState(projects: projects);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(error),
      );
    }
  }

  Future<bool> createProject(ProjectModel project) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final createdProject = await _repository.createProject(project);

      state = ProjectState(projects: [...state.projects, createdProject]);

      return true;
    } catch (error) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: _cleanError(error),
      );

      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      await _repository.deleteProject(id);

      state = state.copyWith(
        projects: state.projects.where((project) => project.id != id).toList(),
        clearError: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(errorMessage: _cleanError(error));

      return false;
    }
  }

  Future<void> refreshProjects() async {
    try {
      final projects = await _repository.getProjects();

      state = ProjectState(projects: projects);
    } catch (error) {
      state = state.copyWith(errorMessage: _cleanError(error));
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _cleanError(Object error) {
    var message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }

    return message;
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, ProjectState>(
  ProjectNotifier.new,
);

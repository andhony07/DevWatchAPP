import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl({ProjectRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? ProjectRemoteDataSource();

  final ProjectRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProjectModel>> getProjects() {
    return _remoteDataSource.getProjects();
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) {
    return _remoteDataSource.createProject(project);
  }

  @override
  Future<void> deleteProject(String id) {
    return _remoteDataSource.deleteProject(id);
  }
}

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/project_model.dart';

class ProjectRemoteDataSource {
  ProjectRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _dio.get<dynamic>('/projects');

      final data = response.data;
      final List<dynamic> projectList;

      if (data is List) {
        projectList = data;
      } else if (data is Map<String, dynamic>) {
        final nestedData = data['data'];

        if (nestedData is List) {
          projectList = nestedData;
        } else if (nestedData is Map<String, dynamic> &&
            nestedData['projects'] is List) {
          projectList = nestedData['projects'] as List<dynamic>;
        } else if (data['projects'] is List) {
          projectList = data['projects'] as List<dynamic>;
        } else {
          throw const FormatException(
            'Projects were not found in the server response.',
          );
        }
      } else {
        throw const FormatException('Invalid projects response.');
      }

      return projectList
          .whereType<Map>()
          .map(
            (project) =>
                ProjectModel.fromJson(Map<String, dynamic>.from(project)),
          )
          .toList();
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    try {
      final response = await _dio.post<dynamic>(
        '/projects',
        data: project.toJson(),
      );

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid create-project response.');
      }

      final nestedData = data['data'];

      if (nestedData is Map<String, dynamic>) {
        final nestedProject = nestedData['project'];

        if (nestedProject is Map<String, dynamic>) {
          return ProjectModel.fromJson(nestedProject);
        }

        return ProjectModel.fromJson(nestedData);
      }

      final projectData = data['project'];

      if (projectData is Map<String, dynamic>) {
        return ProjectModel.fromJson(projectData);
      }

      return ProjectModel.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _dio.delete<dynamic>('/projects/$id');
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];

      if (message != null) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The DevWatch server request timed out.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the DevWatch server.';

      default:
        return 'Project request failed.';
    }
  }
}

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid response received from the authentication server.',
        );
      }

      return LoginResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      throw Exception(_getErrorMessage(error));
    }
  }

  String _getErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ?? responseData['error'];

      if (message != null) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The server request timed out.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the DevWatch server.';

      default:
        return 'Authentication request failed.';
    }
  }
}

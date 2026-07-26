import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    await SecureStorageService.saveAccessToken(response.accessToken);

    return response.user;
  }

  @override
  Future<void> logout() async {
    await SecureStorageService.deleteAccessToken();
  }

  @override
  Future<bool> hasStoredSession() async {
    final token = await SecureStorageService.getAccessToken();

    return token != null && token.isNotEmpty;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        isLoading = false,
        errorMessage = null;

  final AuthStatus status;
  final AuthUser? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository {
    return ref.read(authRepositoryProvider);
  }

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    try {
      final hasSession = await _repository.hasStoredSession();

      if (!hasSession) {
        state = const AuthState(
          status: AuthStatus.unauthenticated,
        );
        return;
      }

      // A token exists locally.
      //
      // When the backend provides a /me or /profile endpoint,
      // this should validate the token and retrieve the real user.
      const restoredUser = AuthUser(
        id: 'stored-session',
        name: 'DevWatch User',
        email: 'developer@devwatch.local',
        role: 'DevOps Engineer',
      );

      state = const AuthState(
        status: AuthStatus.authenticated,
        user: restoredUser,
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.unauthenticated,
      );
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final user = await _repository.login(
        email: email.trim(),
        password: password,
      );

      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

      return true;
    } catch (error) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        errorMessage: _cleanErrorMessage(error),
      );

      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      state = const AuthState(
        status: AuthStatus.unauthenticated,
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }

  String _cleanErrorMessage(Object error) {
    var message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }

    return message;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
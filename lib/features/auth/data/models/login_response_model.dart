import 'auth_user_model.dart';

class LoginResponseModel {
  const LoginResponseModel({required this.accessToken, required this.user});

  final String accessToken;
  final AuthUserModel user;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    final responseData = data is Map<String, dynamic> ? data : json;

    final userData = responseData['user'];

    if (userData is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid login response: user data is missing.',
      );
    }

    final token =
        responseData['accessToken'] ??
        responseData['token'] ??
        json['accessToken'] ??
        json['token'];

    if (token == null || token.toString().isEmpty) {
      throw const FormatException(
        'Invalid login response: access token is missing.',
      );
    }

    return LoginResponseModel(
      accessToken: token.toString(),
      user: AuthUserModel.fromJson(userData),
    );
  }
}

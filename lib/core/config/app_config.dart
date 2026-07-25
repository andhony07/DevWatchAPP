import '../constants/app_constants.dart';

class AppConfig {
  AppConfig._();

  static const String appName = AppConstants.appName;
  static const String baseUrl = AppConstants.baseUrl;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}

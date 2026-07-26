import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.alertNotifications = true,
    this.aiRecommendations = true,
    this.autoRefresh = true,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool alertNotifications;
  final bool aiRecommendations;
  final bool autoRefresh;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? alertNotifications,
    bool? aiRecommendations,
    bool? autoRefresh,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alertNotifications: alertNotifications ?? this.alertNotifications,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      autoRefresh: autoRefresh ?? this.autoRefresh,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void setAlertNotifications(bool value) {
    state = state.copyWith(alertNotifications: value);
  }

  void setAiRecommendations(bool value) {
    state = state.copyWith(aiRecommendations: value);
  }

  void setAutoRefresh(bool value) {
    state = state.copyWith(autoRefresh: value);
  }

  void resetSettings() {
    state = const AppSettings();
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

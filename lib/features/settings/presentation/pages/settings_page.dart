import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Configure appearance, notifications, and monitoring preferences.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  _SettingsSection(
                    title: 'Appearance',
                    children: [
                      RadioGroup<ThemeMode>(
                        groupValue: settings.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .setThemeMode(value);
                          }
                        },
                        child: const Column(
                          children: [
                            RadioListTile<ThemeMode>(
                              value: ThemeMode.system,
                              title: Text('System'),
                              subtitle: Text('Follow your device appearance'),
                            ),
                            RadioListTile<ThemeMode>(
                              value: ThemeMode.light,
                              title: Text('Light'),
                            ),
                            RadioListTile<ThemeMode>(
                              value: ThemeMode.dark,
                              title: Text('Dark'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SettingsSection(
                    title: 'Notifications',
                    children: [
                      SwitchListTile(
                        title: const Text('Notifications'),
                        subtitle: const Text(
                          'Enable application notifications',
                        ),
                        value: settings.notificationsEnabled,
                        onChanged: (value) {
                          ref
                              .read(settingsProvider.notifier)
                              .setNotificationsEnabled(value);
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Alert Notifications'),
                        subtitle: const Text(
                          'Receive infrastructure alert notifications',
                        ),
                        value: settings.alertNotifications,
                        onChanged: settings.notificationsEnabled
                            ? (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .setAlertNotifications(value);
                              }
                            : null,
                      ),
                      SwitchListTile(
                        title: const Text('AI Recommendations'),
                        subtitle: const Text(
                          'Receive AI-generated recommendations',
                        ),
                        value: settings.aiRecommendations,
                        onChanged: settings.notificationsEnabled
                            ? (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .setAiRecommendations(value);
                              }
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _SettingsSection(
                    title: 'Monitoring',
                    children: [
                      SwitchListTile(
                        title: const Text('Auto Refresh'),
                        subtitle: const Text(
                          'Automatically refresh monitoring information',
                        ),
                        value: settings.autoRefresh,
                        onChanged: (value) {
                          ref
                              .read(settingsProvider.notifier)
                              .setAutoRefresh(value);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(settingsProvider.notifier).resetSettings();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings restored to defaults.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore Defaults'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

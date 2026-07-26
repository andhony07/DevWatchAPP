import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _destinations = [
    _Destination(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    _Destination(
      label: 'Projects',
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      route: '/projects',
    ),
    _Destination(
      label: 'Monitoring',
      icon: Icons.monitor_heart_outlined,
      selectedIcon: Icons.monitor_heart,
      route: '/monitoring',
    ),
    _Destination(
      label: 'Alerts',
      icon: Icons.warning_amber_outlined,
      selectedIcon: Icons.warning_amber,
      route: '/alerts',
    ),
    _Destination(
      label: 'AI Analysis',
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome,
      route: '/ai-analysis',
    ),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final index = _destinations.indexWhere(
      (destination) => location.startsWith(destination.route),
    );

    return index < 0 ? 0 : index;
  }

  void _navigate(BuildContext context, int index) {
    context.go(_destinations[index].route);
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logout();

    if (!context.mounted) {
      return;
    }

    context.go('/login');
  }

  Future<void> _handleAccountAction(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    switch (value) {
      case 'profile':
        context.go('/profile');
        break;

      case 'notifications':
        context.go('/notifications');
        break;

      case 'settings':
        context.go('/settings');
        break;

      case 'logout':
        await _logout(context, ref);
        break;
    }
  }

  void _showMobileAccountMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/notifications');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.go('/settings');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();

                    await _logout(context, ref);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _selectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isExtendedRail = constraints.maxWidth >= 1200;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: isExtendedRail,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    _navigate(context, index);
                  },
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Icon(Icons.monitor_heart, size: 32),
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PopupMenuButton<String>(
                          tooltip: 'Account',
                          onSelected: (value) {
                            _handleAccountAction(context, ref, value);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem<String>(
                              value: 'profile',
                              child: ListTile(
                                leading: Icon(Icons.person_outline),
                                title: Text('Profile'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'notifications',
                              child: ListTile(
                                leading: Icon(Icons.notifications_outlined),
                                title: Text('Notifications'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'settings',
                              child: ListTile(
                                leading: Icon(Icons.settings_outlined),
                                title: Text('Settings'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'logout',
                              child: ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Logout'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: isExtendedRail
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.account_circle_outlined),
                                      SizedBox(width: 12),
                                      Text('Account'),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  )
                                : const Icon(Icons.account_circle_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                  destinations: _destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: SafeArea(child: child)),
              ],
            ),
          );
        }

        return Scaffold(
          body: SafeArea(bottom: false, child: child),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  _navigate(context, index);
                },
                destinations: _destinations
                    .map(
                      (destination) => NavigationDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selectedIcon),
                        label: destination.label,
                      ),
                    )
                    .toList(),
              ),
              SafeArea(
                top: false,
                child: SizedBox(
                  height: 42,
                  child: TextButton.icon(
                    onPressed: () {
                      _showMobileAccountMenu(context, ref);
                    },
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text('Account & Settings'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
}

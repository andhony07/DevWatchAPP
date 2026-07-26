import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_analysis/presentation/pages/ai_analysis_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/auth/presentation/pages/auth_gate_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/monitoring/presentation/pages/monitoring_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.matchedLocation;

      final isAuthGate = location == '/';
      final isLoginPage = location == '/login';

      switch (authState.status) {
        case AuthStatus.initial:
          if (!isAuthGate) {
            return '/';
          }
          return null;

        case AuthStatus.unauthenticated:
          if (!isLoginPage) {
            return '/login';
          }
          return null;

        case AuthStatus.authenticated:
          if (isAuthGate || isLoginPage) {
            return '/dashboard';
          }
          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'authGate',
        builder: (context, state) => const AuthGatePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/projects',
            name: 'projects',
            builder: (context, state) => const ProjectsPage(),
          ),
          GoRoute(
            path: '/monitoring',
            name: 'monitoring',
            builder: (context, state) => const MonitoringPage(),
          ),
          GoRoute(
            path: '/alerts',
            name: 'alerts',
            builder: (context, state) => const AlertsPage(),
          ),
          GoRoute(
            path: '/ai-analysis',
            name: 'aiAnalysis',
            builder: (context, state) => const AiAnalysisPage(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});

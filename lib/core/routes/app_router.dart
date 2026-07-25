import 'package:go_router/go_router.dart';

import '../../features/ai_analysis/presentation/pages/ai_analysis_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/monitoring/presentation/pages/monitoring_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
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
        ],
      ),
    ],
  );
}

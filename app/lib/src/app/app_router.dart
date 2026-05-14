import 'package:billlearn/src/features/history/history_screen.dart';
import 'package:billlearn/src/features/home/home_screen.dart';
import 'package:billlearn/src/features/settings/settings_screen.dart';
import 'package:billlearn/src/features/shared/bottom_nav_scaffold.dart';
import 'package:billlearn/src/features/transaction_detail/transaction_detail_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/transactions/:id',
      builder: (context, state) {
        return TransactionDetailScreen(
          transactionId: state.pathParameters['id']!,
        );
      },
    ),
  ],
);

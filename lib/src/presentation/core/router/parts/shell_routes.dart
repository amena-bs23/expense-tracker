part of '../router.dart';

StatefulShellRoute _shellRoutes(ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return NavigationShell(statefulNavigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(routes: [
        GoRoute(
          path: Routes.category,
          name: Routes.category,
          pageBuilder: (context, state) => const MaterialPage(child: CategoryListPage()),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: Routes.expenseList,
          name: Routes.expenseList,
          pageBuilder: (context, state) => const MaterialPage(child: ExpenseListPage()),
        ),
      ]),
      StatefulShellBranch(routes: [
        GoRoute(
          path: Routes.analytics,
          name: Routes.analytics,
          pageBuilder: (context, state) => const MaterialPage(child: AnalyticsPage()),
        ),
      ]),
    ],
  );
}

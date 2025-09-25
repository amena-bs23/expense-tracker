part of '../router.dart';

List<GoRoute> _categoryRoutes(ref) {
  return [
    GoRoute(
      path: Routes.category,
      name: Routes.category,
      pageBuilder: (context, state) {
        return const MaterialPage(child: CategoryListPage());
      },
    ),
  ];
}

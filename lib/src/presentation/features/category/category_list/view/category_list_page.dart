import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../../core/router/routes.dart';
import '../../add_category/view/category_dialog.dart';
import '../../riverpod/category_provider.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  const CategoryListPage({super.key});

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(logoutProvider, (previous, next) {
      if (next.isSuccess) context.pushReplacementNamed(Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logoutProvider);
    final cat = ref.watch(categoryProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // context.locale.category,
                'Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      await ref.read(categoryProvider.notifier).backupToFile();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Backup saved')),
                        );
                      }
                    },
                    icon: const Icon(Icons.backup),
                    label: const Text('Backup'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(categoryProvider.notifier)
                          .restoreFromFile();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Backup restored')),
                        );
                      }
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Restore'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: cat.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final c = cat.items[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Color(c.color)),
                    title: Text(c.name),
                    subtitle: Text(c.icon),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await showCategoryDialog(context, ref, c);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              ref.read(categoryProvider.notifier).remove(c.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // FilledButton.icon(
            //   onPressed: () {
            //     context.pushNamed(Routes.addCategory);
            //   },
            //   icon: const Icon(Icons.add),
            //   label: const Text('Add Category'),
            // ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      await showCategoryDialog(context, ref, null);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ),
                // const SizedBox(width: 12),
                // Expanded(
                //   child: OutlinedButton.icon(
                //     onPressed: () {
                //       ref.read(logoutProvider.notifier).call();
                //     },
                //     icon: state.isLoading
                //         ? const SizedBox(
                //             width: 16,
                //             height: 16,
                //             child: CircularProgressIndicator(strokeWidth: 2),
                //           )
                //         : const Icon(Icons.logout),
                //     label: state.isLoading
                //         ? const Text('Logging out...')
                //         : Text(context.locale.logout),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../riverpod/expense_provider.dart';
import '../../../category/riverpod/category_provider.dart';

class ExpenseListPage extends ConsumerStatefulWidget {
  const ExpenseListPage({super.key});

  @override
  ConsumerState<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends ConsumerState<ExpenseListPage> {
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
    final exp = ref.watch(expenseProvider);
    final cats = {for (final c in ref.watch(categoryProvider).items) c.id!: c};

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.locale.home),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  onPressed: () async {
                    await ref.read(expenseProvider.notifier).backupToFile();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup saved')),
                      );
                    }
                  },
                  child: const Text('Backup'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    await ref.read(expenseProvider.notifier).restoreFromFile();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup restored')),
                      );
                    }
                  },
                  child: const Text('Restore'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: exp.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final e = exp.items[i];
                  final c = cats[e.categoryId];
                  return ListTile(
                    leading: c != null ? CircleAvatar(backgroundColor: Color(c.color)) : const CircleAvatar(),
                    title: Text('${e.amount.toStringAsFixed(2)} - ${c?.name ?? ''}'),
                    subtitle: Text(e.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => ref.read(expenseProvider.notifier).remove(e.id!),
                    ),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed: () {
                ref.read(logoutProvider.notifier).call();
              },
              child: state.isLoading
                  ? const LoadingIndicator()
                  : Text(context.locale.logout),
            ),
          ],
        ),
      ),
    );
  }
}

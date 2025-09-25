import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../riverpod/expense_provider.dart';
import '../../../../../domain/entities/expense_entity.dart';
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.locale.home,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search description'),
                    onChanged: (v) => ref.read(expenseProvider.notifier).updateFilters(search: v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int>(
                    value: null,
                    hint: const Text('Filter by category'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All categories')),
                      for (final c in cats.values)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => ref.read(expenseProvider.notifier).updateFilters(categoryId: v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final from = await showDatePicker(
                        context: context,
                        firstDate: DateTime(now.year - 5),
                        lastDate: now,
                        initialDate: now,
                      );
                      if (from == null) return;
                      final to = await showDatePicker(
                        context: context,
                        firstDate: from,
                        lastDate: DateTime(now.year + 5),
                        initialDate: from,
                      );
                      if (to == null) return;
                      ref.read(expenseProvider.notifier).updateFilters(
                            fromMs: DateTime(from.year, from.month, from.day).millisecondsSinceEpoch,
                            toMs: DateTime(to.year, to.month, to.day, 23, 59, 59).millisecondsSinceEpoch,
                          );
                    },
                    icon: const Icon(Icons.date_range),
                    label: const Text('Date range'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(expenseProvider.notifier).backupToFile();
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
                      await ref.read(expenseProvider.notifier).restoreFromFile();
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
              child: RefreshIndicator(
                onRefresh: () async => ref.read(expenseProvider.notifier).refresh(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 100) {
                      ref.read(expenseProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                itemCount: exp.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final e = exp.items[i];
                  final c = cats[e.categoryId];
                  return ListTile(
                    leading: c != null ? CircleAvatar(backgroundColor: Color(c.color)) : const CircleAvatar(),
                    title: Text('${e.amount.toStringAsFixed(2)} - ${c?.name ?? ''}'),
                    subtitle: Text('${DateTime.fromMillisecondsSinceEpoch(e.dateMs).toLocal().toString().split(' ').first} • ${e.description}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final amountCtrl = TextEditingController(text: e.amount.toStringAsFixed(2));
                            final descCtrl = TextEditingController(text: e.description);
                            int selectedCat = e.categoryId;
                            final formKey = GlobalKey<FormState>();

                            await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Edit Expense'),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: amountCtrl,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(labelText: 'Amount'),
                                        validator: (v) {
                                          final n = double.tryParse(v ?? '');
                                          if (n == null) return 'This field is required';
                                          if (n <= 0) return 'Value must be positive';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: descCtrl,
                                        decoration: const InputDecoration(labelText: 'Description'),
                                        validator: (v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null,
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButton<int>(
                                        value: selectedCat,
                                        items: [
                                          for (final c in cats.values)
                                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                                        ],
                                        onChanged: (v) => selectedCat = v!,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                  FilledButton(
                                    onPressed: () async {
                                      if (!formKey.currentState!.validate()) return;
                                      await ref.read(expenseProvider.notifier).edit(
                                        ExpenseEntity(
                                          id: e.id,
                                          amount: double.parse(amountCtrl.text),
                                          description: descCtrl.text.trim(),
                                          categoryId: selectedCat,
                                          dateMs: e.dateMs,
                                        ),
                                      );
                                      if (context.mounted) Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Expense updated')),
                                      );
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => ref.read(expenseProvider.notifier).remove(e.id!),
                        ),
                      ],
                    ),
                  );
                    },
                  ),
                ),
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

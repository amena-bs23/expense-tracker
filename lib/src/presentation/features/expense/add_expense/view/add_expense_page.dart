import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/application_state/logout_provider/logout_provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../category/riverpod/category_provider.dart';
import '../../riverpod/expense_provider.dart';
import '../../../../../../src/domain/entities/expense_entity.dart';
import '../../../../core/base/status.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utiliity/validation/validation.dart';
import '../../../../../core/utiliity/validation/positive_number_validation.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
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
    final categories = ref.watch(categoryProvider).items;

    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final selectedCategory = ValueNotifier<int?>(categories.isNotEmpty ? categories.first.id : null);
    final selectedDate = ValueNotifier<DateTime>(DateTime.now());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.locale.home),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (v) => context.validator.apply<num>([
                RequiredValidation(),
                PositiveNumberValidation(),
              ])(double.tryParse(v ?? '')),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: context.validator.apply([RequiredValidation()]),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedCategory.value,
              items: [
                for (final c in categories)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => selectedCategory.value = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Date: ${selectedDate.value.toLocal().toString().split(' ').first}'),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: selectedDate.value,
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(builder: (context, ref, _) {
              final expState = ref.watch(expenseProvider);
              final loading = expState.status.isLoading;
              return FilledButton(
                onPressed: loading
                    ? null
                    : () async {
                        final amount = double.tryParse(amountCtrl.text) ?? -1;
                        if (amount <= 0 || descCtrl.text.trim().isEmpty || selectedCategory.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields with valid values')),
                          );
                          return;
                        }
                        await ref.read(expenseProvider.notifier).add(
                              ExpenseEntity(
                                amount: amount,
                                description: descCtrl.text.trim(),
                                categoryId: selectedCategory.value!,
                                dateMs: DateTime(
                                  selectedDate.value.year,
                                  selectedDate.value.month,
                                  selectedDate.value.day,
                                ).millisecondsSinceEpoch,
                              ),
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Expense added')),
                          );
                        }
                      },
                child: loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Add Expense'),
              );
            }),
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

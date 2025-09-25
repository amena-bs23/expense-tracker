import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/category_entity.dart';
import '../riverpod/category_provider.dart';

Future<void> showCategoryDialog(BuildContext context, WidgetRef ref, CategoryEntity? data) async {
  final name = TextEditingController(text: data?.name ?? '');
  final icon = ValueNotifier<String>(data?.icon ?? 'category');
  final color = ValueNotifier<int>(data?.color ?? 0xFF90CAF9);

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(data == null ? 'Add Category' : 'Edit Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: icon.value,
            items: const [
              DropdownMenuItem(value: 'category', child: Text('Category')),
              DropdownMenuItem(value: 'restaurant', child: Text('Food')),
              DropdownMenuItem(value: 'directions_bus', child: Text('Transport')),
              DropdownMenuItem(value: 'movie', child: Text('Entertainment')),
              DropdownMenuItem(value: 'health_and_safety', child: Text('Health')),
              DropdownMenuItem(value: 'shopping_bag', child: Text('Shopping')),
            ],
            onChanged: (v) => icon.value = v!,
          ),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: color.value,
            items: const [
              DropdownMenuItem(value: 0xFF90CAF9, child: Text('Blue')),
              DropdownMenuItem(value: 0xFFFFAB91, child: Text('Deep Orange')),
              DropdownMenuItem(value: 0xFFCE93D8, child: Text('Purple')),
              DropdownMenuItem(value: 0xFFA5D6A7, child: Text('Green')),
              DropdownMenuItem(value: 0xFFFFE082, child: Text('Amber')),
            ],
            onChanged: (v) => color.value = v!,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            final entity = CategoryEntity(
              id: data?.id,
              name: name.text.trim(),
              icon: icon.value,
              color: color.value,
            );
            if (data == null) {
              await ref.read(categoryProvider.notifier).add(entity);
            } else {
              await ref.read(categoryProvider.notifier).edit(entity);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}





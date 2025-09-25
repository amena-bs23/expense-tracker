import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/use_cases/category_use_cases.dart';
import '../../../core/base/status.dart';
import '../../../../core/base/result.dart';

part 'category_provider.g.dart';

class CategoryState {
  const CategoryState({
    this.items = const <CategoryEntity>[],
    this.status = Status.initial,
    this.error,
  });

  final List<CategoryEntity> items;
  final Status status;
  final String? error;

  CategoryState copyWith({
    List<CategoryEntity>? items,
    Status? status,
    String? error,
  }) => CategoryState(
        items: items ?? this.items,
        status: status ?? this.status,
        error: error,
      );
}

@riverpod
class Category extends _$Category {
  late GetCategoriesUseCase _get;
  late CreateCategoryUseCase _create;
  late UpdateCategoryUseCase _update;
  late DeleteCategoryUseCase _delete;

  @override
  CategoryState build() {
    _get = ref.read(getCategoriesUseCaseProvider);
    _create = ref.read(createCategoryUseCaseProvider);
    _update = ref.read(updateCategoryUseCaseProvider);
    _delete = ref.read(deleteCategoryUseCaseProvider);
    _preloadAndRefresh();
    return const CategoryState();
  }

  Future<void> _preloadAndRefresh() async {
    await ref.read(categoryRepositoryProvider).preloadDefaultsIfEmpty();
    await refresh();
  }

  Future<void> refresh() async {
    final items = await _get.call();
    state = state.copyWith(items: items);
  }

  Future<void> add(CategoryEntity data) async {
    state = state.copyWith(status: Status.loading);
    final Result<CategoryEntity, String> res = await _create.call(data);
    state = switch (res) {
      Success() => state.copyWith(status: Status.success),
      Error(:final error) => state.copyWith(status: Status.error, error: error),
      _ => state.copyWith(status: Status.error, error: 'Unknown error'),
    };
    if (state.status.isSuccess) await refresh();
  }

  Future<void> edit(CategoryEntity data) async {
    state = state.copyWith(status: Status.loading);
    final Result<CategoryEntity, String> res = await _update.call(data);
    state = switch (res) {
      Success() => state.copyWith(status: Status.success),
      Error(:final error) => state.copyWith(status: Status.error, error: error),
      _ => state.copyWith(status: Status.error, error: 'Unknown error'),
    };
    if (state.status.isSuccess) await refresh();
  }

  Future<void> remove(int id) async {
    state = state.copyWith(status: Status.loading);
    final Result<void, String> res = await _delete.call(id);
    state = switch (res) {
      Success() => state.copyWith(status: Status.success),
      Error(:final error) => state.copyWith(status: Status.error, error: error),
      _ => state.copyWith(status: Status.error, error: 'Unknown error'),
    };
    if (state.status.isSuccess) await refresh();
  }

  Future<File> backupToFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/categories_backup.json');
    final items = await _get.call();
    final jsonList = items
        .map((e) => {
              'id': e.id,
              'name': e.name,
              'icon': e.icon,
              'color': e.color,
            })
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
    return file;
  }

  Future<void> restoreFromFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/categories_backup.json');
    if (!await file.exists()) return;
    final decoded = jsonDecode(await file.readAsString()) as List<dynamic>;
    final items = decoded
        .map((e) => CategoryEntity(
              id: (e as Map<String, dynamic>)['id'] as int?,
              name: e['name'] as String,
              icon: e['icon'] as String,
              color: e['color'] as int,
            ))
        .toList();
    await ref.read(categoryRepositoryProvider).restore(items);
    await refresh();
  }
}



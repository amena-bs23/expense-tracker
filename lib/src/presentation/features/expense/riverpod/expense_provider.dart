import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/expense_entity.dart';
import '../../../../domain/use_cases/expense_use_cases.dart';
import '../../../core/base/status.dart';

part 'expense_provider.g.dart';

class ExpenseState {
  const ExpenseState({
    this.items = const <ExpenseEntity>[],
    this.status = Status.initial,
    this.error,
  });

  final List<ExpenseEntity> items;
  final Status status;
  final String? error;

  ExpenseState copyWith({
    List<ExpenseEntity>? items,
    Status? status,
    String? error,
  }) => ExpenseState(items: items ?? this.items, status: status ?? this.status, error: error);
}

@riverpod
class Expense extends _$Expense {
  late GetExpensesUseCase _get;
  late AddExpenseUseCase _add;
  late DeleteExpenseUseCase _delete;
  late UpdateExpenseUseCase _update;
  late GetFilteredExpensesUseCase _getFiltered;

  @override
  ExpenseState build() {
    _get = ref.read(getExpensesUseCaseProvider);
    _add = ref.read(addExpenseUseCaseProvider);
    _delete = ref.read(deleteExpenseUseCaseProvider);
    _update = ref.read(updateExpenseUseCaseProvider);
    _getFiltered = ref.read(getFilteredExpensesUseCaseProvider);
    refresh();
    return const ExpenseState();
  }

  Future<void> edit(ExpenseEntity data) async {
    state = state.copyWith(status: Status.loading);
    final Result<ExpenseEntity, String> res = await _update.call(data);
    state = switch (res) {
      Success() => state.copyWith(status: Status.success),
      Error(:final error) => state.copyWith(status: Status.error, error: error),
      _ => state.copyWith(status: Status.error, error: 'Unknown error'),
    };
    if (state.status.isSuccess) await refresh();
  }

  // Pagination/filtering state
  int _page = 0;
  static const int _pageSize = 20;
  int? _filterCategoryId;
  int? _filterFrom;
  int? _filterTo;
  String? _search;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  void updateFilters({int? categoryId, int? fromMs, int? toMs, String? search}) {
    _filterCategoryId = categoryId;
    _filterFrom = fromMs;
    _filterTo = toMs;
    _search = search;
    resetAndLoad();
  }

  Future<void> resetAndLoad() async {
    _page = 0;
    _hasMore = true;
    state = state.copyWith(status: Status.loading);
    final items = await _getFiltered.call(
      limit: _pageSize,
      offset: 0,
      categoryId: _filterCategoryId,
      dateFromMs: _filterFrom,
      dateToMs: _filterTo,
      search: _search,
    );
    _hasMore = items.length == _pageSize;
    state = state.copyWith(items: items, status: Status.success);
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page += 1;
    final items = await _getFiltered.call(
      limit: _pageSize,
      offset: _page * _pageSize,
      categoryId: _filterCategoryId,
      dateFromMs: _filterFrom,
      dateToMs: _filterTo,
      search: _search,
    );
    _hasMore = items.length == _pageSize;
    state = state.copyWith(items: [...state.items, ...items]);
  }

  Future<void> refresh() async {
    final items = await _get.call();
    state = state.copyWith(items: items);
  }

  Future<void> add(ExpenseEntity data) async {
    state = state.copyWith(status: Status.loading);
    final Result<ExpenseEntity, String> res = await _add.call(data);
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
    final file = File('${dir.path}/expenses_backup.json');
    final items = await _get.call();
    final jsonList = items
        .map((e) => {
              'id': e.id,
              'amount': e.amount,
              'description': e.description,
              'category_id': e.categoryId,
              'date_ms': e.dateMs,
            })
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
    return file;
  }

  Future<void> restoreFromFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/expenses_backup.json');
    if (!await file.exists()) return;
    final decoded = jsonDecode(await file.readAsString()) as List<dynamic>;
    final items = decoded
        .map((e) => ExpenseEntity(
              id: (e as Map<String, dynamic>)['id'] as int?,
              amount: (e['amount'] as num).toDouble(),
              description: e['description'] as String,
              categoryId: e['category_id'] as int,
              dateMs: e['date_ms'] as int,
            ))
        .toList();
    await ref.read(expenseRepositoryProvider).restore(items);
    await refresh();
  }
}






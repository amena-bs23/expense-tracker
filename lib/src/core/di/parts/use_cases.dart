part of '../dependency_injection.dart';

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
CreateCategoryUseCase createCategoryUseCase(Ref ref) {
  return CreateCategoryUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
UpdateCategoryUseCase updateCategoryUseCase(Ref ref) {
  return UpdateCategoryUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
DeleteCategoryUseCase deleteCategoryUseCase(Ref ref) {
  return DeleteCategoryUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
BackupCategoriesUseCase backupCategoriesUseCase(Ref ref) {
  return BackupCategoriesUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
RestoreCategoriesUseCase restoreCategoriesUseCase(Ref ref) {
  return RestoreCategoriesUseCase(ref.read(categoryRepositoryProvider));
}

@riverpod
GetExpensesUseCase getExpensesUseCase(Ref ref) {
  return GetExpensesUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
AddExpenseUseCase addExpenseUseCase(Ref ref) {
  return AddExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
DeleteExpenseUseCase deleteExpenseUseCase(Ref ref) {
  return DeleteExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
BackupExpensesUseCase backupExpensesUseCase(Ref ref) {
  return BackupExpensesUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
RestoreExpensesUseCase restoreExpensesUseCase(Ref ref) {
  return RestoreExpensesUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
UpdateExpenseUseCase updateExpenseUseCase(Ref ref) {
  return UpdateExpenseUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
GetFilteredExpensesUseCase getFilteredExpensesUseCase(Ref ref) {
  return GetFilteredExpensesUseCase(ref.read(expenseRepositoryProvider));
}

@riverpod
GetTotalsUseCase getTotalsUseCase(Ref ref) {
  return GetTotalsUseCase(ref.read(analyticsRepositoryProvider));
}

@riverpod
GetBreakdownUseCase getBreakdownUseCase(Ref ref) {
  return GetBreakdownUseCase(ref.read(analyticsRepositoryProvider));
}

@riverpod
GetTopCategoriesUseCase getTopCategoriesUseCase(Ref ref) {
  return GetTopCategoriesUseCase(ref.read(analyticsRepositoryProvider));
}

@riverpod
GetDailyTrendsUseCase getDailyTrendsUseCase(Ref ref) {
  return GetDailyTrendsUseCase(ref.read(analyticsRepositoryProvider));
}

@riverpod
GetAveragesUseCase getAveragesUseCase(Ref ref) {
  return GetAveragesUseCase(ref.read(analyticsRepositoryProvider));
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
CheckRememberMeUseCase checkRememberMeUseCase(Ref ref) {
  return CheckRememberMeUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
SaveRememberMeUseCase saveRememberMeUseCase(Ref ref) {
  return SaveRememberMeUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetCurrentLocaleUseCase getCurrentLocaleUseCase(Ref ref) {
  return GetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
SetCurrentLocaleUseCase setCurrentLocaleUseCase(Ref ref) {
  return SetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

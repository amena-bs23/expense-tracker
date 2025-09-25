part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  final db = SqfliteDatabaseService();
  // Fire-and-forget init; callers should await if needed
  db.initialize();
  return db;
}

@riverpod
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider));
}

part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    local: ref.read(cacheServiceProvider),
    database: ref.read(databaseServiceProvider),
  );
}

@Riverpod(keepAlive: true)
RouterRepository routerRepository(Ref ref) {
  return RouterRepositoryImpl(cacheService: ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
LocaleRepository localeRepository(Ref ref) {
  return LocaleRepositoryImpl(ref.read(cacheServiceProvider));
}

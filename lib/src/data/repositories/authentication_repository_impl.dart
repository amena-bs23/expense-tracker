import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/entities/sign_up_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/user_model.dart';
import '../services/cache/cache_service.dart';
import '../services/database/database_service.dart';

final class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.local,
    required this.database,
  });

  final CacheService local;
  final DatabaseService database;

  @override
  Future<SignUpResponseEntity> register(SignUpRequestEntity data) async {
    final existing = await database.findUserByEmail(data.email);
    if (existing != null) {
      throw Exception('Email already registered');
    }

    final passwordHash = _hashPassword(data.password);
    final user = UserModel(
      email: data.email,
      firstName: data.firstName,
      lastName: data.lastName,
      passwordHash: passwordHash,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await database.insertUser(user.toDb());

    return SignUpResponseEntity(accessToken: _fakeTokenFor(data.email));
  }

  @override
  Future<Result<LoginResponseEntity, Failure>> login(
    LoginRequestEntity data,
  ) async {
    return asyncGuard(() async {
      final row = await database.findUserByEmail(data.username);
      if (row == null) {
        throw Exception('Invalid credentials');
      }

      final user = UserModel.fromDb(row);
      final providedHash = _hashPassword(data.password);
      if (providedHash != user.passwordHash) {
        throw Exception('Invalid credentials');
      }

      if (data.shouldRemeber ?? false) await _saveSession();

      final token = _fakeTokenFor(user.email);
      return LoginResponseEntity(accessToken: token);
    });
  }

  Future<void> _saveSession() async {
    await local.save(CacheKey.isLoggedIn, true);
  }

  /// Manages the "Remember Me" functionality.
  ///
  /// When [rememberMe] is null, retrieves the current setting from cache.
  /// When [rememberMe] has a value, updates the setting in cache.
  /// Returns the current or newly saved value, defaulting to false on errors.
  @override
  Future<bool> rememberMe({bool? rememberMe}) async {
    try {
      if (rememberMe == null) {
        return local.get<bool>(CacheKey.rememberMe) ?? false;
      }

      await local.save(CacheKey.rememberMe, rememberMe);

      return rememberMe;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> forgotPassword(Map<String, dynamic> data) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> data) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOTP(Map<String, dynamic> data) {
    // TODO: implement verifyOTP
    throw UnimplementedError();
  }

  @override
  Future<String> resendOTP(Map<String, dynamic> data) {
    // TODO: implement resendOTP
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await local.remove([CacheKey.isLoggedIn, CacheKey.rememberMe]);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  String _fakeTokenFor(String email) => base64Url.encode(utf8.encode('local:$email'));
}

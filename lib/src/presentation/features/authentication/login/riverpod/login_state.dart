import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/base/status.dart';

export 'package:flutter_template/src/presentation/core/base/status.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState<T> with _$LoginState<T> {
  const factory LoginState({
    @Default(false) bool rememberMe,
    @Default(Status.initial) Status status,
    String? error,
  }) = _LoginState<T>;

  const LoginState._();
}

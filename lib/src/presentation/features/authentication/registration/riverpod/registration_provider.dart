import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/sign_up_entity.dart';
import '../../../../core/base/status.dart';
import '../../../../../domain/use_cases/authentication_use_case.dart';

part 'registration_provider.g.dart';

class RegistrationState {
  const RegistrationState({this.status = Status.initial, this.error});

  final Status status;
  final String? error;

  RegistrationState copyWith({Status? status, String? error}) =>
      RegistrationState(status: status ?? this.status, error: error);
}

@riverpod
class Registration extends _$Registration {
  late RegisterUseCase _registerUseCase;

  @override
  RegistrationState build() {
    _registerUseCase = ref.read(registerUseCaseProvider);
    return const RegistrationState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: Status.loading, error: null);

    final request = SignUpRequestEntity(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    try {
      await _registerUseCase.call(request);
      state = state.copyWith(status: Status.success);
    } catch (e) {
      state = state.copyWith(status: Status.error, error: e.toString());
    }
  }
}



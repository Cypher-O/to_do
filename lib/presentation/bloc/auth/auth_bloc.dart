import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do/domain/usecases/login_usecase.dart';
import 'package:to_do/domain/usecases/register_usecase.dart';
import 'package:to_do/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.secureStorage,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    // on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        await secureStorage.write(key: 'token', value: user.token);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.username, event.email, event.password);
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        await secureStorage.write(key: 'token', value: user.token);
        emit(AuthSuccess(user));
      },
    );
  }

  // Future<void> _onLogoutRequested(
  //   LogoutRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   await secureStorage.delete(key: 'token');
  //   emit(AuthInitial());
  // }
}
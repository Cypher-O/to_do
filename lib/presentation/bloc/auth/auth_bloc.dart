import 'package:to_do/core/utils/imports/plugin_import.dart';
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
    on<CheckAuthentication>(_onCheckAuthentication);
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

 Future<void> _onCheckAuthentication(
    CheckAuthentication event,
    Emitter<AuthState> emit,
  ) async {
    final token = await secureStorage.read(key: 'token');
    if (token != null) {
      emit(AuthSuccess(User(token: token)));
    } else {
      emit(AuthInitial());
    }
  }
}
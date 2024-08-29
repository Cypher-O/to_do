import 'package:http/http.dart' as http;
import 'package:to_do/core/utils/imports/plugin_import.dart';
import 'package:to_do/domain/repositories/auth_repositories.dart';
import 'package:to_do/domain/usecases/login_usecase.dart';
import 'package:to_do/domain/usecases/register_usecase.dart';
import 'package:to_do/presentation/bloc/auth/auth_bloc.dart';
import 'package:to_do/data/datasources/auth_remote_data_source.dart';
import 'package:to_do/data/repositories/auth_repository_impl.dart';

// Todo imports
import 'package:to_do/domain/repositories/todo_repository.dart';
import 'package:to_do/domain/usecases/get_todos_usecase.dart';
import 'package:to_do/domain/usecases/add_todo_usecase.dart';
import 'package:to_do/domain/usecases/update_todo_usecase.dart';
import 'package:to_do/domain/usecases/delete_todo_usecase.dart';
import 'package:to_do/data/datasources/todo_remote_data_source.dart';
import 'package:to_do/data/repositories/todo_repository_impl.dart';
import 'package:to_do/presentation/bloc/todo/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      secureStorage: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // Todo
  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      addTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
      secureStorage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodosUseCase(sl()));
  sl.registerLazySingleton(() => AddTodoUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTodoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTodoUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(client: sl()),
  );
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/domain/usecases/get_todos_usecase.dart';
import 'package:to_do/domain/usecases/add_todo_usecase.dart';
import 'package:to_do/domain/usecases/update_todo_usecase.dart';
import 'package:to_do/domain/usecases/delete_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodos;
  final AddTodoUseCase addTodo;
  final UpdateTodoUseCase updateTodo;
  final DeleteTodoUseCase deleteTodo;
  final FlutterSecureStorage secureStorage;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.secureStorage,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final token = await secureStorage.read(key: 'token');
    if (token == null) {
      emit(const TodoError('Not authenticated'));
      return;
    }
    final result = await getTodos(token);
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      emit(TodoLoading());
      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(const TodoError('Not authenticated'));
        return;
      }
      final result = await addTodo(event.title, event.description, token);
      result.fold(
        (failure) => emit(TodoError(failure.message)),
        (newTodo) => emit(TodoLoaded([...currentState.todos, newTodo])),
      );
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      emit(TodoLoading());
      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(const TodoError('Not authenticated'));
        return;
      }
      final result = await updateTodo(event.updatedTodo, token);
      result.fold(
        (failure) => emit(TodoError(failure.message)),
        (updatedTodo) => emit(TodoLoaded(currentState.todos.map((todo) =>
            todo.id == updatedTodo.id ? updatedTodo : todo).toList())),
      );
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      emit(TodoLoading());
      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(const TodoError('Not authenticated'));
        return;
      }
      final result = await deleteTodo(event.id, token);
      result.fold(
        (failure) => emit(TodoError(failure.message)),
        (_) => emit(TodoLoaded(currentState.todos.where((todo) => todo.id != event.id).toList())),
      );
    }
  }
}
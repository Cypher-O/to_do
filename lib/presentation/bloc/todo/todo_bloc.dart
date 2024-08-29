import 'package:to_do/core/utils/imports/plugin_import.dart';
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
      emit(const TodoError(message: 'Not authenticated'));
      return;
    }
    
    final result = await getTodos(token);
    result.fold(
      (failure) => emit(TodoError(message: failure.message)),
      (todos) {
        final username = todos.isNotEmpty ? todos.first.username : '';
        emit(TodoLoaded(todos: todos, username: username!));
      },
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final temporaryTodo = Todo(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        title: event.title,
        description: event.description,
        completed: false,
        username: currentState.username, // Use the current username
      );

      emit(TodoLoaded(todos: [...currentState.todos, temporaryTodo], username: currentState.username));

      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(TodoError(message: 'Not authenticated', username: currentState.username));
        return;
      }
      final result = await addTodo(event.title, event.description, token);
      result.fold(
        (failure) {
          emit(TodoLoaded(todos: currentState.todos, username: currentState.username));
          emit(TodoError(message: failure.message, username: currentState.username));
        },
        (newTodo) {
          final updatedTodos = [...currentState.todos];
          final tempIndex = updatedTodos.indexWhere((todo) => todo.id == temporaryTodo.id);
          if (tempIndex != -1) {
            updatedTodos[tempIndex] = newTodo;
          } else {
            updatedTodos.add(newTodo);
          }
          emit(TodoLoaded(todos: updatedTodos, username: currentState.username));
        },
      );
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final optimisticTodos = currentState.todos.map((todo) =>
          todo.id == event.updatedTodo.id ? event.updatedTodo : todo).toList();
      emit(TodoLoaded(todos: optimisticTodos, username: currentState.username));

      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(TodoError(message: 'Not authenticated', username: currentState.username));
        return;
      }
      final result = await updateTodo(event.updatedTodo, token);
      result.fold(
        (failure) {
          emit(TodoLoaded(todos: currentState.todos, username: currentState.username));
          emit(TodoError(message: failure.message, username: currentState.username));
        },
        (updatedTodo) {
          // If the update succeeds, we don't need to do anything as the UI is already updated
        },
      );
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded) {
      final deletedTodos = currentState.todos.where((todo) => todo.id != event.id).toList();
      emit(TodoLoaded(todos: deletedTodos, username: currentState.username));

      final token = await secureStorage.read(key: 'token');
      if (token == null) {
        emit(TodoError(message: 'Not authenticated', username: currentState.username));
        return;
      }
      final result = await deleteTodo(event.id, token);
      result.fold(
        (failure) {
          emit(TodoLoaded(todos: currentState.todos, username: currentState.username));
          emit(TodoError(message: failure.message, username: currentState.username));
        },
        (_) {
          // If the delete operation succeeds, no need to update the state as it is already updated
        },
      );
    }
  }
}
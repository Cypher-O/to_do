import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<Either<Failure, Todo>> call(Todo todo, String token) async {
    return await repository.updateTodo(todo, token);
  }
}
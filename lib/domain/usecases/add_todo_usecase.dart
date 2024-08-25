import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/domain/repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<Either<Failure, Todo>> call(String title, String description, String token) async {
    return await repository.addTodo(title, description, token);
  }
}
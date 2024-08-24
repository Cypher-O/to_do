import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/domain/repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<Either<Failure, List<Todo>>> call() async {
    return await repository.getTodos();
  }
}
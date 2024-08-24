import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> addTodo(String title);
  Future<Either<Failure, Todo>> updateTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(int id);
}
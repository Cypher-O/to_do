import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos(String token);
  Future<Either<Failure, Todo>> addTodo(String title, String description, String token);
  Future<Either<Failure, Todo>> updateTodo(Todo todo, String token);
  Future<Either<Failure, void>> deleteTodo(String id, String token);
}
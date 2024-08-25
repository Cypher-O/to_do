import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/todo.dart';
import 'package:to_do/domain/repositories/todo_repository.dart';
import 'package:to_do/data/datasources/todo_remote_data_source.dart';
import 'package:to_do/data/models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos(String token) async {
    try {
      final todos = await remoteDataSource.getTodos(token);
      return Right(todos);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Todo>> addTodo(String title, String description, String token) async {
    try {
      final todo = await remoteDataSource.addTodo(title, description, token);
      return Right(todo);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo, String token) async {
    try {
      final updatedTodo = await remoteDataSource.updateTodo(todo as TodoModel, token);
      return Right(updatedTodo);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id, String token) async {
    try {
      await remoteDataSource.deleteTodo(id, token);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }
}
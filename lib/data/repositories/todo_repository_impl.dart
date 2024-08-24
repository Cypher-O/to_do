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
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await remoteDataSource.getTodos();
      return Right(todos);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Todo>> addTodo(String title) async {
    try {
      final todo = await remoteDataSource.addTodo(title);
      return Right(todo);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      final updatedTodo = await remoteDataSource.updateTodo(todo as TodoModel);
      return Right(updatedTodo);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int id) async {
    try {
      await remoteDataSource.deleteTodo(id);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }
}
import 'package:to_do/domain/repositories/auth_repositories.dart';
import 'package:to_do/domain/entities/user.dart';
import 'package:to_do/data/datasources/auth_remote_data_source.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, User>> register(String username, String email, String password) async {
    try {
      final user = await remoteDataSource.register(username, email, password);
      return Right(user);
    } on ServerFailure catch (failure) {
      return Left(failure);
    }
  }
}
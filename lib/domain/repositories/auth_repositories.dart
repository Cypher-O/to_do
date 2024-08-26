import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String username, String email, String password);
}
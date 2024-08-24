import 'package:dartz/dartz.dart';
import 'package:to_do/core/errors/failures.dart';
import 'package:to_do/domain/entities/user.dart';
import 'package:to_do/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
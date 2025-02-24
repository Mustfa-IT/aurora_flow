import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call(String email, String password,
      confirmPassword, String name, Uint8List? avatarImage) async {
    try {
      if (confirmPassword != password) {
        return Left(VailditonFailure(message: 'Mismatch Passowrd'));
      }
      final user = await repository.register(
        email,
        password,
        confirmPassword,
        name,
        avatarImage ?? Uint8List(0),
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(
          message: "Invalid email or password $e",
          exceptionMessage: e.toString()));
    }
  }
}

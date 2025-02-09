import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call(
      String email, String password, String name) async {
    try {
      final user = await repository.register(email, password, name);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(
          message: "Invalid email or password",
          exceptionMessage: e.toString()));
    }
  }
}

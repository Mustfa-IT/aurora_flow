import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Either<Failure, void> call(){
    try {
      repository.logout();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(
          message: "Server Could not logout, please try again",
          exceptionMessage: e.toString()));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class OnUserVerify {
  final AuthRepository _authRepository;

  OnUserVerify(this._authRepository);

  Future<Either<Failure, void>> call(String userId, Function callback) async {
    try {
      await _authRepository.onUserVerfied(userId, callback);
      print("user id in onUserVerify: $userId");
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(
          message: "An error occurred while verifying the user",
          exceptionMessage: e.toString()));
    }
  }
}

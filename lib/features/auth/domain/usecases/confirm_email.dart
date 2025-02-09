import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class ConfirmEmail {
  final AuthRepository _authRepository;

  ConfirmEmail(this._authRepository);

  Future<Either<Failure, void>> call(String token) async {
    return TaskEither<Failure, void>(() async {
      try {
        await _authRepository.confirmEmail(token);
        return right(null);
      } catch (e) {
        return left(ServerFailure(
            message: "Server Could not confirm email, please try again"));
      }
    }).run();
  }
}

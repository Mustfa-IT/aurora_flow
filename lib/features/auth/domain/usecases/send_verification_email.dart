import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class SendVerificationEmail {
  final AuthRepository repository;

  SendVerificationEmail(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return TaskEither<Failure, void>(() async {
      try {
        await repository.sendVerificationEmail(email);
        return right(null);
      } catch (e) {
        return left(
          ServerFailure(
            message:
                "Server Could not send verification email, please try again",
            exceptionMessage: e.toString(),
          ),
        );
      }
    }).run();
  }
}

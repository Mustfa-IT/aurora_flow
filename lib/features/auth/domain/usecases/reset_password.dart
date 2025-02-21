import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class ResetPassword {
  final AuthRepository _authRepository;

  ResetPassword(this._authRepository);

  Future<Either<Failure, void>> call(String email) async {
    try {
      await _authRepository.resetPassword(email);
      return right(null);
    } catch (e) {
      return left(VailditonFailure(message: e.toString()));
    }
  }
}

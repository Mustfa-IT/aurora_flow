import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class RefreshToken {
  final AuthRepository _authRepository;

  RefreshToken(this._authRepository);

  Future<Either<Failure, void>> call() async {
    try {
      await _authRepository.refreshAuthToken();
      return right(null);
    } catch (e) {
      return left(VailditonFailure(message: e.toString()));
    }
  }
}

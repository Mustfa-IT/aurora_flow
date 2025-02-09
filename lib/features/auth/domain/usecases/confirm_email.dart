import 'package:fpdart/fpdart.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class ConfirmEmail {
  final AuthRepository _authRepository;

  ConfirmEmail(this._authRepository);

  Future<Either<Failure,void>> call(String token) async {
    return await _authRepository.confirmEmail(token);
  }
}
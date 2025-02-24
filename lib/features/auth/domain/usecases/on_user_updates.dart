import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class OnUserUpdates {
  final AuthRepository _userRepository;

  OnUserUpdates(this._userRepository);

  Future<void> call(String userId, Function callBack) async {
    return await _userRepository.onUserUpdates(userId, callBack);
  }
}

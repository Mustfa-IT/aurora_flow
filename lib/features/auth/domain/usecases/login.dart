import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
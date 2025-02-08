
import 'package:task_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  Future<User> login(String email, String password);
}

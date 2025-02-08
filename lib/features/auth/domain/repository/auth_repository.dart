import 'package:task_app/features/auth/domain/entities/user.dart';

/// A repository interface for handling authentication-related operations.
///
/// This repository defines the contract for logging in a user with the provided
/// email and password, and returns a [User] entity upon successful authentication.
abstract class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  Future<User> login(String email, String password);
}

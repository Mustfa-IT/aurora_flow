import 'package:task_app/features/auth/domain/entities/user.dart';

/// A repository interface for handling authentication-related operations.
///
/// This repository defines the contract for logging in a user with the provided
/// email and password, and returns a [User] entity upon successful authentication.
abstract class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  Future<User> login(String email, String password);

  /// Registers a user with the given [email] and [password].
  Future<User> register(String email, String password, String name);

  /// Logs out the current user.
  void logout();

  /// Sends a verification email to the provided [email].
  Future<void> sendVerificationEmail(String email);

  /// Confirms the email of the user with the provided [token].
  Future<void> confirmEmail(String token);
}

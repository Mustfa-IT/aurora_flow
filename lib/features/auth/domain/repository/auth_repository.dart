import 'dart:typed_data';

import 'package:task_app/features/auth/domain/entities/user.dart';

/// A repository interface for handling authentication-related operations.
///
/// This repository defines the contract for logging in a user with the provided
/// email and password, and returns a [User] entity upon successful authentication.
abstract class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  Future<User> login(String email, String password);

  /// Registers a user with the given [email] and [password].
  Future<User> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    Uint8List avatarImage,
  );

  /// Logs out the current user.
  void logout();

  /// Sends a verification email to the provided [email].
  Future<void> sendVerificationEmail(String email);

  /// Refreshes the user's authentication token.
  Future<void> refreshAuthToken();

  /// Reset the user's password.
  Future<void> resetPassword(String email);

  /// Subscribes to user updates.
  Future<void> onUserUpdates(String userId, Function callBack);
}

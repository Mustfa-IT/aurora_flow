part of 'auth_bloc.dart';

/// Base class for all authentication events.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when a login is requested.
class AuthLoginRequested extends AuthEvent {
  /// The email of the user attempting to log in.
  final String email;

  /// The password of the user attempting to log in.
  final String password;

  /// Creates an instance of [AuthLoginRequested].
  ///
  /// Both [email] and [password] are required.
  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassowrd;
  final String name;
  final Uint8List? avatarImage;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassowrd,
    required this.name,
    required this.avatarImage,
  });
}

class AuthUserUpdated extends AuthEvent {
  final User updatedUser;
  const AuthUserUpdated({required this.updatedUser});

  @override
  List<Object> get props => [updatedUser];
}

class AuthRequestVerifyEmail extends AuthEvent {
  final String userId;
  final String email;

  const AuthRequestVerifyEmail({
    required this.userId,
    required this.email,
  });
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthEmailVerifiedCallBack extends AuthEvent {
  final String email;
  const AuthEmailVerifiedCallBack({
    required this.email,
  });
}

/// Event to check if there is an active user session.
class AuthCheckSession extends AuthEvent {
  /// Creates an instance of [AuthCheckSession].
  const AuthCheckSession();
}

/// Event triggered when a password reset is requested.
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});
}

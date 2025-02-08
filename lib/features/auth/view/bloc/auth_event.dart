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

/// Event to check if there is an active user session.
class AuthCheckSession extends AuthEvent {
  /// Creates an instance of [AuthCheckSession].
  const AuthCheckSession();
}

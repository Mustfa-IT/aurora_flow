part of 'auth_bloc.dart';

/// Represents the various states of authentication.
///
/// This is an abstract class that extends [Equatable] to allow for value comparison.
abstract class AuthState extends Equatable {
  final User? user;
  const AuthState({required this.user});

  @override
  List<Object?> get props => [];
}

/// Initial state of authentication.
class AuthInitial extends AuthState {
  const AuthInitial() : super(user: null);
}

/// State emitted when authentication is in progress.
class AuthLoading extends AuthState {
  const AuthLoading() : super(user: null);
}

/// State emitted when authentication is successful.
///
/// Contains the authenticated [user].
class AuthSuccess extends AuthState {
  const AuthSuccess({required User user}) : super(user: user);

  @override
  List<Object?> get props => [user];
}

/// State emitted when authentication fails.
///
/// Contains the [error] message.
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error, super.user});

  @override
  List<Object?> get props => [error];
}

class AuthVerifySent extends AuthState {
  final String email;

  const AuthVerifySent({required this.email, super.user});

  @override
  List<Object?> get props => [email];
}

class AuthEmailVerified extends AuthState {
  final String email;

  const AuthEmailVerified({required this.email, super.user});

  @override
  List<Object?> get props => [email];
}

class AuthEmailNotVerified extends AuthState {
  final String email;
  final String error;

  const AuthEmailNotVerified(
      {required this.email, required this.error, super.user});

  @override
  List<Object?> get props => [email];
}

/// State emitted when a valid session exists.
///
/// Contains the authenticated [user].
class AuthSessionActive extends AuthState {
  const AuthSessionActive({super.user});

  @override
  List<Object?> get props => [user];
}

/// State emitted when no active session is found.
class AuthSessionEmpty extends AuthState {
  const AuthSessionEmpty({super.user});
}

class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent({required this.email, super.user});

  @override
  List<Object?> get props => [email];
}

class AuthPasswordResetFailed extends AuthState {
  final String email;
  final String error;

  const AuthPasswordResetFailed({required this.email, required this.error, super.user});

  @override
  List<Object?> get props => [email, error];
}

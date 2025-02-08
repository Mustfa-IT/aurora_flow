part of 'auth_bloc.dart';

/// Represents the various states of authentication.
///
/// This is an abstract class that extends [Equatable] to allow for value comparison.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state of authentication.
class AuthInitial extends AuthState {}

/// State emitted when authentication is in progress.
class AuthLoading extends AuthState {}

/// State emitted when authentication is successful.
///
/// Contains the authenticated [user].
class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State emitted when authentication fails.
///
/// Contains the [error] message.
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// State emitted when a valid session exists.
///
/// Contains the authenticated [user].
class AuthSessionActive extends AuthState {
  final User user;

  const AuthSessionActive({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State emitted when no active session is found.
class AuthSessionEmpty extends AuthState {}

part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
/// State emitted when a valid session exists.
class AuthSessionActive extends AuthState {
  final User user;
  
  const AuthSessionActive({required this.user});
  
  @override
  List<Object?> get props => [user];
}

/// State emitted when no active session is found.
class AuthSessionEmpty extends AuthState {}
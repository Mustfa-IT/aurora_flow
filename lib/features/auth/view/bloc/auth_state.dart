part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final User? user;
  const AuthState({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(user: null);
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(user: null);
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required User user}) : super(user: user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error, User? user}) : super(user: user);

  @override
  List<Object?> get props => [error, user];
}

class AuthVerifySent extends AuthState {
  final String email;
  const AuthVerifySent({required this.email, User? user}) : super(user: user);

  @override
  List<Object?> get props => [email, user];
}

class AuthEmailVerified extends AuthState {
  final String email;
  const AuthEmailVerified({required this.email, User? user}) : super(user: user);

  @override
  List<Object?> get props => [email, user];
}

class AuthEmailNotVerified extends AuthState {
  final String email;
  final String error;
  const AuthEmailNotVerified({required this.email, required this.error, User? user})
      : super(user: user);

  @override
  List<Object?> get props => [email, error, user];
}

class AuthSessionActive extends AuthState {
  const AuthSessionActive({required User user}) : super(user: user);

  @override
  List<Object?> get props => [user];
}

class AuthSessionEmpty extends AuthState {
  const AuthSessionEmpty() : super(user: null);
}

class AuthPasswordResetSent extends AuthState {
  final String email;
  const AuthPasswordResetSent({required this.email, User? user}) : super(user: user);

  @override
  List<Object?> get props => [email, user];
}

class AuthPasswordResetFailed extends AuthState {
  final String email;
  final String error;
  const AuthPasswordResetFailed({required this.email, required this.error, User? user})
      : super(user: user);

  @override
  List<Object?> get props => [email, error, user];
}

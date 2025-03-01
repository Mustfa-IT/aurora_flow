part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final Uint8List? avatarImage;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    required this.avatarImage,
  });

  @override
  List<Object> get props =>
      [email, password, confirmPassword, name, avatarImage ?? ''];
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

  @override
  List<Object> get props => [userId, email];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthEmailVerifiedCallBack extends AuthEvent {
  final String email;

  const AuthEmailVerifiedCallBack({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class AuthCheckSession extends AuthEvent {
  const AuthCheckSession();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthUpdateUsernameRequested extends AuthEvent {
  final String name;
  
  const AuthUpdateUsernameRequested({required this.name});

  @override
  List<Object> get props => [name];
}
class AuthUpdateAvatarRequested extends AuthEvent {
  final Uint8List image;
  
  const AuthUpdateAvatarRequested({required this.image});

  @override
  List<Object> get props => [image];
}
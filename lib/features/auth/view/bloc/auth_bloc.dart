import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/usecases/login.dart';
import 'package:task_app/features/auth/domain/usecases/logout.dart';
import 'package:task_app/features/auth/domain/usecases/on_user_updates.dart';
import 'package:task_app/features/auth/domain/usecases/refresh_token.dart';
import 'package:task_app/features/auth/domain/usecases/register.dart';
import 'package:task_app/features/auth/domain/usecases/reset_password.dart';
import 'package:task_app/features/auth/domain/usecases/send_verification_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final SendVerificationEmail sendVerificationEmail;
  final OnUserUpdates onUserUpdates;
  final Logout logout;
  final RefreshToken refreshToken;
  final ResetPassword resetPassword;
  final PocketBase pocketBase;

  AuthBloc({
    required this.login,
    required this.register,
    required this.sendVerificationEmail,
    required this.onUserUpdates,
    required this.logout,
    required this.refreshToken,
    required this.resetPassword,
    required this.pocketBase,
  }) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthCheckSession>(_onCheckSession);
    on<AuthRequestVerifyEmail>(_onRequestVerifyEmail);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthEmailVerifiedCallBack>(_onEmailVerifiedCallBack);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthUserUpdated>(_onUserUpdated);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await login(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(error: failure.message)),
        (user) => emit(AuthSuccess(user: user)),
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await register(
        event.email,
        event.password,
        event.confirmPassword,
        event.name,
        event.avatarImage,
      );
      result.fold(
        (failure) => emit(AuthFailure(error: failure.message)),
        (user) => emit(AuthSuccess(user: user)),
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    if (pocketBase.authStore.isValid) {
      final result = await refreshToken();
      result.fold(
        (failure) => emit(const AuthSessionEmpty()),
        (_) async => await _checkAuthStore(emit),
      );
    } else {
      emit(const AuthSessionEmpty());
    }
  }

  Future<void> _checkAuthStore(Emitter<AuthState> emit) async {
    final record = pocketBase.authStore.record;
    if (record != null && pocketBase.authStore.isValid) {
      try {
        final user = User.fromJson(record.toJson());
        emit(AuthSessionActive(user: user));

        // Listen for updates on the user.
        await onUserUpdates(user.id, (updatedUser) {
          if (updatedUser is User) {
            add(AuthUserUpdated(updatedUser: updatedUser));
          }
        });
      } catch (e) {
        emit(const AuthSessionEmpty());
      }
    }
  }

  Future<void> _onRequestVerifyEmail(
    AuthRequestVerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await sendVerificationEmail(event.email);
      result.fold(
        (failure) => emit(
          AuthEmailNotVerified(email: event.email, error: failure.message),
        ),
        (_) async {
          emit(AuthVerifySent(email: event.email));
          // Listen for email verification updates.
          await onUserUpdates(event.userId, (user) {
            if (user is User) {
              if (state.user == null) {
                return;
              }
              if (user.verified && !state.user!.verified) {
                add(AuthEmailVerifiedCallBack(email: user.email));
              } else {
                emit(AuthEmailNotVerified(
                  email: user.email,
                  error: 'Email not verified',
                ));
              }
            }
          });
        },
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onEmailVerifiedCallBack(
    AuthEmailVerifiedCallBack event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthEmailVerified(email: event.email));
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    final result = logout();
    result.fold(
      (failure) => emit(AuthFailure(error: failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await resetPassword(event.email);
      result.fold(
        (failure) => emit(
          AuthPasswordResetFailed(email: event.email, error: failure.message),
        ),
        (_) => emit(AuthPasswordResetSent(email: event.email)),
      );
    } catch (e) {
      emit(AuthPasswordResetFailed(email: event.email, error: e.toString()));
    }
  }

  void _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthSessionActive) {
      // Optionally refresh token in the background.
      refreshToken();
      emit(AuthSessionActive(user: event.updatedUser));
    }
  }
}

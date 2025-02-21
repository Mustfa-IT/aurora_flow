import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/usecases/login.dart';
import 'package:task_app/features/auth/domain/usecases/logout.dart';
import 'package:task_app/features/auth/domain/usecases/register.dart';
import 'package:task_app/features/auth/domain/usecases/send_verification_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// The `AuthBloc` class is responsible for handling authentication-related events and states.
/// It extends the `Bloc` class from the `flutter_bloc` package and manages the following events:
/// - `AuthLoginRequested`: Triggered when a login request is made.
/// - `AuthCheckSession`: Triggered to check if there is an active session.
///
/// The `AuthBloc` class uses the following dependencies:
/// - `Login`: A use case for handling login logic.
/// - `PocketBase`: An instance of PocketBase for session management.
///
/// The initial state of the `AuthBloc` is `AuthInitial`.
///
/// Methods:
/// - `_onLoginRequested`: Handles the `AuthLoginRequested` event. It attempts to log in the user
///   with the provided email and password, and emits `AuthLoading`, `AuthSuccess`, or `AuthFailure`
///   states based on the outcome.
/// - `_onCheckSession`: Handles the `AuthCheckSession` event. It checks the PocketBase instance
///   for a valid session and emits `AuthSessionActive` or `AuthSessionEmpty` states based on the
///   session status.
///
/// Usage:
///
/// To use the `AuthBloc`, you can dispatch events to it using the `add` method.
/// ```dart
///   context.read<AuthBloc>().add(AuthLoginRequested(email: 'user@example.com', password: 'password'));
/// ```
///
/// You can also listen to the state changes in the UI using the `BlocBuilder` widget.
/// in the UI:
/// ```dart
/// BlocBuilder<AuthBloc, AuthState>(
///   builder: (context, state) {
///     if (state is AuthLoading) {
///       return CircularProgressIndicator();
///     } else if (state is AuthSuccess) {
///       return Text('Logged in as: ${state.user.email}');
///     } else if (state is AuthFailure) {
///       return Text('Login failed: ${state.error}');
///     } else {
///       return ElevatedButton(
///         onPressed: () {
///           // Dispatch the AuthCheckSession event
///           context.read<AuthBloc>().add(AuthCheckSession());
///         },
///         child: Text('Check Session'),
///       );
///     }
///   },
/// )
/// ```

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final SendVerificationEmail verifyEmail;
  final Logout logout;
  final PocketBase pocketBase;
  AuthBloc({
    required this.login,
    required this.register,
    required this.verifyEmail,
    required this.logout,
    required this.pocketBase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthCheckSession>(_onCheckSession);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthRequestVerifyEmail>(_onRequestVerifyEmail);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }
  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    var res = logout();
    res.fold((l) {
      emit(AuthFailure(error: l.message));
    }, (r) {
      emit(AuthInitial());
    });
  }

  Future<void> _onRequestVerifyEmail(
    AuthRequestVerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await verifyEmail(event.email);
      response.fold((l) {
        emit(AuthEmailNotVerified(email: event.email, error: l.message));
      }, (r) {
        emit(AuthVerifySent(email: event.email));
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final respone = await register(
          event.email, event.password, event.confirmPassowrd, event.name);
      respone.fold((l) {
        emit(AuthFailure(error: l.message));
      }, (r) {
        emit(AuthSuccess(user: r));
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final reponse = await login(event.email, event.password);
      reponse.fold((l) {
        emit(AuthFailure(error: l.message));
      }, (r) {
        emit(AuthSuccess(user: r));
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    // Check the PocketBase instance for a valid session
    if (pocketBase.authStore.isValid) {
      // Retrieve the stored record.
      final record = pocketBase.authStore.record;
      // Convert the record (assumed to be a Map<String, dynamic>) to a User entity.
      if (record == null) {
        emit(AuthSessionEmpty());
        return;
      }
      var recordMap = record.toJson();
      final user = User(
        id: recordMap['id'] as String,
        email: recordMap['email'] as String,
        collectionId: recordMap['collectionId'],
        collectionName: recordMap['collectionName'],
        emailVisibility: recordMap['emailVisibility'],
        verified: recordMap['verified'] == 'true' ? true : false,
        avatar: recordMap['avatar'],
        created: DateTime.parse(recordMap['created']),
        updated: DateTime.parse(recordMap['updated']),
      );
      emit(AuthSessionActive(user: user));
    } else {
      emit(AuthSessionEmpty());
    }
  }
}

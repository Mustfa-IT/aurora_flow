import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/usecases/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final PocketBase pocketBase;
  AuthBloc({
    required this.login,
    required this.pocketBase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthCheckSession>(_onCheckSession);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await login(event.email, event.password);
      emit(AuthSuccess(user: user));
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
      );
      emit(AuthSessionActive(user: user));
    } else {
      emit(AuthSessionEmpty());
    }
  }
}

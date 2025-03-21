/// Sets up the service locator with necessary dependencies for the application.
///
/// This function registers various services and repositories with the service locator
/// to enable dependency injection throughout the application. It configures the
/// PocketBase instance, remote data sources, repositories, use cases, and BLoC.
///
/// The function also handles platform-specific implementations for authentication
/// storage using cookies for web and SharedPreferences for mobile.
///
/// Parameters:
/// - [sharedPreferences]: An instance of [SharedPreferences] for storing authentication data on mobile.
///
/// Returns:
/// A [Future] that completes when the setup is done.
//Future<void> setupLocator(SharedPreferences sharedPreferences) async {}

/// Creates an [AsyncAuthStore] for storing authentication data.
///
/// This function creates an [AsyncAuthStore] with platform-specific implementations:
/// - For web, it uses cookies to store authentication data.
/// - For mobile, it uses [SharedPreferences] to store authentication data.
///
/// Returns:
/// A [Future] that completes with an [AsyncAuthStore] instance.
library;

// Future<AsyncAuthStore> createAuthStore() async {}
import 'package:task_app/features/auth/domain/usecases/logout.dart';
import 'package:task_app/features/auth/domain/usecases/on_user_updates.dart';
import 'package:task_app/features/auth/domain/usecases/refresh_token.dart';
import 'package:task_app/features/auth/domain/usecases/register.dart';
import 'package:task_app/features/auth/domain/usecases/reset_password.dart';
import 'package:task_app/features/auth/domain/usecases/send_verification_email.dart';
import 'package:task_app/features/auth/domain/usecases/update_avatar.dart';
import 'package:task_app/features/auth/domain/usecases/update_username.dart';
import 'package:task_app/features/home/data/data_sources/project_remote_source.dart';
import 'package:task_app/features/home/data/repository/project_repo_impl.dart';
import 'package:task_app/features/home/domain/repository/project_repo.dart';
import 'package:task_app/features/home/view/bloc/project_bloc.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/config/config.dart';
import 'package:task_app/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:task_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/login.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';

final sl = GetIt.instance; // 'sl' stands for Service Locator

Future<void> setupLocator(SharedPreferences sharedPreferences) async {
  // Create the AsyncAuthStore using SharedPreferences.
  final authStore = await createAuthStore();

  // Create and register a global PocketBase instance configured with the AsyncAuthStore.
  final pocketBase = PocketBase(Config.pocketBaseUrl, authStore: authStore);
  sl.registerLazySingleton<PocketBase>(() => pocketBase);
  initAuth();
  initPojects();
}

void initPojects() async {
  // Register the remote data source.
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(pocketBase: sl<PocketBase>()),
  );

  // Register the repository (injecting the remote data source).
  sl.registerLazySingleton<ProjectRepository>(
    () =>
        ProjectRepositoryImpl(remoteDataSource: sl<ProjectRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProjectBloc>(
      () => ProjectBloc(sl<ProjectRepository>()));
}

void initAuth() async {
  // Register the remote data source, now injecting the shared PocketBase instance.
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(pocketBase: sl<PocketBase>()),
  );

  // Register the repository (injecting both remote and local data sources).
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );

  // Register the login use case.
  sl.registerLazySingleton<Login>(() => Login(sl<AuthRepository>()));

  // Register the register use case.
  sl.registerLazySingleton<Register>(() => Register(sl<AuthRepository>()));
  // Register the send verification email use case.
  sl.registerLazySingleton(() => SendVerificationEmail(sl<AuthRepository>()));
  // Register the on user verify use case.
  sl.registerLazySingleton(() => OnUserUpdates(sl<AuthRepository>()));
  // Register the logout use case.
  sl.registerLazySingleton(() => Logout(sl<AuthRepository>()));
  // Register the refresh token use case.
  sl.registerLazySingleton(() => RefreshToken(sl<AuthRepository>()));
  // Register the reset password use case.
  sl.registerLazySingleton(() => ResetPassword(sl<AuthRepository>()));
  // Register the update username use case.
  sl.registerLazySingleton(() => UpdateUsername(sl<AuthRepository>()));
  //  Register the update avatar use case.
  sl.registerLazySingleton(() => UpdateAvatar(sl<AuthRepository>()));
  // Register the AuthBloc.
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
        login: sl<Login>(),
        pocketBase: sl<PocketBase>(),
        register: sl<Register>(),
        sendVerificationEmail: sl<SendVerificationEmail>(),
        onUserUpdates: sl<OnUserUpdates>(),
        refreshToken: sl<RefreshToken>(),
        resetPassword: sl<ResetPassword>(),
        updateUsername: sl<UpdateUsername>(),
        updateAvatar: sl<UpdateAvatar>(),
        logout: sl<Logout>()),
  );
}

Future<AsyncAuthStore> createAuthStore() async {
  if (kIsWeb) {
    // Web-specific implementation using cookies
    return AsyncAuthStore(
      save: (String data) async {
        final expires = DateTime.now().add(Duration(days: 30));
        final cookie =
            'pb_auth=$data; SameSite=Lax; expires=${expires.toIso8601String()}; path=/';
        html.document.cookie = cookie;
      },
      initial: () {
        // Retrieve the cookie value
        final cookies = html.document.cookie?.split('; ');
        if (cookies != null) {
          for (final cookie in cookies) {
            final keyValue = cookie.split('=');
            if (keyValue[0] == 'pb_auth') {
              return keyValue[1];
            }
          }
        }
        return null;
      }(),
    );
  } else {
    // Mobile-specific implementation using SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    return AsyncAuthStore(
      save: (String data) async {
        await sharedPreferences.setString('pb_auth', data);
      },
      initial: sharedPreferences.getString('pb_auth'),
    );
  }
}

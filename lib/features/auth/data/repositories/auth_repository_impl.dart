import 'package:flutter/foundation.dart';
import 'package:task_app/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

/// Implementation of the [AuthRepository] interface.
///
/// This class is responsible for handling authentication-related operations
/// by utilizing the [AuthRemoteDataSource] to interact with the remote data source.
///
/// The [AuthRepositoryImpl] class provides methods to perform user login.
///
/// - [remoteDataSource]: The remote data source used for authentication operations.
///
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    // Attempt login using the remote data source (PocketBase).
    final userModel = await remoteDataSource.login(email, password);

    return userModel;
  }

  @override
  Future<User> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    Uint8List avatarImage,
  ) {
    final userModel = remoteDataSource.register(
        email, password, confirmPassword, name, avatarImage);
    return userModel;
  }

  @override
  void logout() {
    remoteDataSource.logout();
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    return await remoteDataSource.sendVerificationEmail(email);
  }
  @override
  Future<void> refreshAuthToken() {
    return remoteDataSource.refreshAuthToken();
  }

  @override
  Future<void> resetPassword(String email) {
    return remoteDataSource.resetPassword(email);
  }
  
  @override
  Future<void> onUserUpdates(String userId, Function callBack) {
    return remoteDataSource.onUserUpdates(userId, callBack);
  }
}

import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/data/models/user_model.dart';

/// An abstract class that defines the contract for remote authentication data source.
abstract class AuthRemoteDataSource {
  /// Logs in a user with the provided [email] and [password].
  ///
  /// Returns a [UserModel] containing user data if the login is successful.
  ///
  /// Throws an [Exception] if the login fails.
  Future<UserModel> login(String email, String password);
}

/// Implementation of [AuthRemoteDataSource] that uses PocketBase for authentication.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// The PocketBase instance used for making authentication requests.
  final PocketBase pocketBase;

  /// Creates an instance of [AuthRemoteDataSourceImpl] with the given [pocketBase] instance.
  ///
  /// The [pocketBase] instance is required and must be injected.
  AuthRemoteDataSourceImpl({required this.pocketBase});

  @override

  /// Logs in a user with the provided [email] and [password] using PocketBase.
  ///
  /// Calls PocketBase’s `authWithPassword` method on the 'users' collection.
  ///
  /// Returns a [UserModel] containing user data if the login is successful.
  ///
  /// Throws an [Exception] if the login fails.
  Future<UserModel> login(String email, String password) async {
    try {
      final authResponse = await pocketBase
          .collection('users')
          .authWithPassword(email, password);

      return UserModel.fromJson(authResponse.record.toJson());
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}

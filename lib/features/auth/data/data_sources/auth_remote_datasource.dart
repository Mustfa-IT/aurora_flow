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

  /// Registers a user with the provided [email] and [password].
  /// Returns a [UserModel] containing user data if the registration is successful.
  /// Throws an [Exception] if the registration fails.
  ///
  Future<UserModel> register(
      String email, String password, String confirmPassword, String name);

  /// Logs out the current user.
  /// Throws an [Exception] if the logout fails.
  void logout();

  /// Sends a verification email to the provided [email].
  /// Throws an [Exception] if the email fails to send.
  Future<void> sendVerificationEmail(String email);

  /// Confirms the email of the user with the provided [token].
  /// Throws an [Exception] if the email confirmation fails.
  Future<void> confirmEmail(String token);
}

/// Implementation of [AuthRemoteDataSource] that uses PocketBase for authentication.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// The PocketBase instance used for making authentication requests.
  final PocketBase pocketBase;

  /// Creates an instance of [AuthRemoteDataSourceImpl] with the given [pocketBase] instance.
  ///
  /// The [pocketBase] instance is required and must be injected.
  AuthRemoteDataSourceImpl({required this.pocketBase});

  /// Logs in a user with the provided [email] and [password] using PocketBase.
  ///
  /// Calls PocketBase’s `authWithPassword` method on the 'users' collection.
  ///
  /// Returns a [UserModel] containing user data if the login is successful.
  ///
  /// Throws an [Exception] if the login fails.
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final authResponse = await pocketBase
          .collection('users')
          .authWithPassword(email, password);

      return UserModel.fromJson(authResponse.record.toJson().toString());
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<UserModel> register(String email, String password,
      String confirmPassword, String name) async {
    try {
      final body = <String, dynamic>{
        "password": password,
        "passwordConfirm": confirmPassword,
        "email": email,
        "emailVisibility": true,
        "name": name,
      };

      final authResponse =
          await pocketBase.collection('users').create(body: body);
      return UserModel.fromJson(authResponse.toJson().toString());
    } catch (e) {
      throw Exception("failed: $e");
    }
  }

  @override
  void logout() {
    pocketBase.authStore.clear();
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    await pocketBase.collection('users').requestVerification(email);
    return Future.value();
  }

  @override
  Future<void> confirmEmail(String token) async {
    await pocketBase.collection('users').confirmVerification(token);
  }
}

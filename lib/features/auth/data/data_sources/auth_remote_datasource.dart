import 'dart:typed_data';

import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    String email,
    String password,
    String confirmPassword,
    String name,
    Uint8List avatarImage,
  );

  /// Logs out the current user.
  /// Throws an [Exception] if the logout fails.
  void logout();

  /// Sends a verification email to the provided [email].
  /// Throws an [Exception] if the email fails to send.
  Future<void> sendVerificationEmail(String email);

  /// Refreshes the user's authentication token.
  /// Throws an [Exception] if the token refresh fails.
  /// Returns a [Future] that completes when the token is refreshed.
  Future<void> refreshAuthToken();

  /// Subscribes to user updates.
  ///
  /// This method takes a [userId] and a [callBack] function. The [callBack] function
  /// will be executed with the updated user data.
  ///
  /// - Parameters:
  ///   - userId: The ID of the user to subscribe to updates for.
  ///   - callBack: A function to be called with the updated user data.
  ///
  /// - Returns: A [Future] that completes when the subscription is done.
  Future<void> onUserUpdates(String userId, Function callBack);

  /// Reset the user's password.
  ///
  /// This method takes a [email] and sends a password reset email to the user.
  ///
  Future<void> resetPassword(String email);

  /// Update the user's username.
  /// This method takes a [name] and [userId] and updates the user's username.
  /// Returns a [UserModel] containing user data if the update is successful.
  /// Throws an [Exception] if the update fails.
  Future<UserModel> updateUsername(String name, String userId);

  /// Update the user's avatar.
  /// This method takes a [image] and updates the user's avatar.
  /// Returns a [UserModel] containing user data if the update is successful.
  /// Throws an [Exception] if the update fails.
  Future<UserModel> updateAvatar(Uint8List image);
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

      return UserModel.fromJson(authResponse.record.toJson());
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    Uint8List avatarImage,
  ) async {
    try {
      final body = <String, dynamic>{
        "password": password,
        "passwordConfirm": confirmPassword,
        "email": email,
        "emailVisibility": true,
        "name": name,
      };

      final authResponse = await pocketBase.collection('users').create(
        body: body,
        files: [
          if (avatarImage.isNotEmpty && avatarImage.length > 1)
            http.MultipartFile.fromBytes(
              'avatar',
              avatarImage,
              filename: 'avatar.jpg', // Provide a valid filename
              contentType: MediaType(
                  'image', 'jpeg'), // Optionally specify the content type
            ),
        ],
      );
      return UserModel.fromJson(authResponse.toJson());
    } catch (e) {
      print(e.toString());
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
  Future<void> onUserUpdates(String userId, Function callBack) async {
    await pocketBase.collection('users').subscribe(userId, (e) {
      callBack(UserModel.fromJson(e.record!.toJson()));
    });
  }

  @override
  Future<void> refreshAuthToken() async {
    print("refreshing token");
    await pocketBase.collection('users').authRefresh();
  }

  @override
  Future<void> resetPassword(String email) async {
    await pocketBase.collection('users').requestPasswordReset(email);
  }

  @override
  Future<UserModel> updateUsername(String name, String userId) {
    final body = <String, dynamic>{
      "name": name,
    };

    return pocketBase.collection('users').update(userId, body: body).then(
          (value) => UserModel.fromJson(
            value.toJson(),
          ),
        );
  }

  @override
  Future<UserModel> updateAvatar(Uint8List image) {
    return pocketBase
        .collection('users')
        .update(pocketBase.authStore.record!.id, files: [
      if (image.isNotEmpty && image.length > 1)
        http.MultipartFile.fromBytes(
          'avatar',
          image,
          filename: 'avatar.jpg', // Provide a valid filename
        ),
    ]).then(
      (value) => UserModel.fromJson(
        value.toJson(),
      ),
    );
  }
}

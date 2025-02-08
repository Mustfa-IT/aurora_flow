import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

/// Implementation that uses PocketBase for authentication.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final PocketBase pocketBase;

  /// Now we require a PocketBase instance that is injected.
  AuthRemoteDataSourceImpl({required this.pocketBase});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Call PocketBase’s authWithPassword method on the 'users' collection.
      final authResponse =
          await pocketBase.collection('users').authWithPassword(email, password);

      // The response contains a 'record' (user data) in JSON format.
      return UserModel.fromJson(authResponse.record.toJson());
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}

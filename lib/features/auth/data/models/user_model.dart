
import 'package:task_app/features/auth/domain/entities/user.dart';

/// A data model class that extends the [User] entity to include JSON serialization.
///
/// The [UserModel] class provides methods to convert between JSON and the [User] entity.
///
/// Example usage:
/// ```dart
/// // Creating a UserModel instance from JSON
/// final userModel = UserModel.fromJson({
///   'id': '123',
///   'email': 'example@example.com',
/// });
///
/// // Converting a UserModel instance to JSON
/// final json = userModel.toJson();
/// ```
///
/// See also:
/// - [User] for the base entity class.

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}

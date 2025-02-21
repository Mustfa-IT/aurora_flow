import 'package:task_app/features/auth/domain/entities/user.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    required super.collectionId,
    required super.collectionName,
    required super.emailVisibility,
    required super.verified,
    required super.avatar,
    required super.created,
    required super.updated,
  });
  User copyWith({
    String? id,
    String? email,
    String? collectionId,
    String? collectionName,
    String? emailVisibility,
    bool? verified,
    String? avatar,
    DateTime? created,
    DateTime? updated,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      avatar: avatar ?? this.avatar,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'avatar': avatar,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      collectionId: map['collectionId'] as String,
      collectionName: map['collectionName'] as String,
      emailVisibility: map['emailVisibility'] as String,
      verified: map['verified'] as bool,
      avatar: map['avatar'] as String,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, collectionId: $collectionId, collectionName: $collectionName, emailVisibility: $emailVisibility, verified: $verified, avatar: $avatar, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.collectionId == collectionId &&
        other.collectionName == collectionName &&
        other.emailVisibility == emailVisibility &&
        other.verified == verified &&
        other.avatar == avatar &&
        other.created == created &&
        other.updated == updated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        collectionId.hashCode ^
        collectionName.hashCode ^
        emailVisibility.hashCode ^
        verified.hashCode ^
        avatar.hashCode ^
        created.hashCode ^
        updated.hashCode;
  }
}

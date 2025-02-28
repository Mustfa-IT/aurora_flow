// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// A class representing a user entity.
///
/// The [User] class contains the user's unique identifier and email address.
///
/// {
//  "collectionId": "_pb_users_auth_",
//  "collectionName": "users",
//  "id": "test",
//  "email": "test@example.com",
//  "emailVisibility": true,
//  "verified": true,
//  "name": "test",
//  "avatar": "filename.jpg",
//  "created": "2022-01-01 10:00:00.123Z",
//  "updated": "2022-01-01 10:00:00.123Z"
//}
class User {
  /// The unique identifier of the user.
  final String id;

  /// The email address of the user.
  final String email;
  final String name;
  final String collectionId;
  final String collectionName;
  final bool emailVisibility;
  final bool verified;
  final String avatar;
  final DateTime created;
  final DateTime updated;

  /// Creates a new [User] instance with the given [id] and [email].
  ///
  /// Both [id] and [email] are required and must not be null.
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.collectionId,
    required this.collectionName,
    required this.emailVisibility,
    required this.verified,
    required this.avatar,
    required this.created,
    required this.updated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'avatar': avatar,
      'created': created.toString(),
      'updated': updated.toString(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      collectionId: map['collectionId'] as String,
      collectionName: map['collectionName'] as String,
      emailVisibility: map['emailVisibility'] as bool,
      verified: map['verified'] as bool,
      avatar: map['avatar'] as String,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(Map<String, dynamic> source) => User.fromMap(source);
}

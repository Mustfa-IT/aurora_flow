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
}

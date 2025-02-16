/// A class representing a user entity.
///
/// The [User] class contains the user's unique identifier and email address.
class User {
  /// The unique identifier of the user.
  final String id;

  /// The email address of the user.
  final String? email;

  /// Creates a new [User] instance with the given [id] and [email].
  ///
  /// Both [id] and [email] are required and must not be null.
  User({
    required this.id,
    required this.email,
  });
}

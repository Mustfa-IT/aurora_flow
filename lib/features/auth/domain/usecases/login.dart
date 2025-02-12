import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

/// A use case class that handles user login.
///
/// This class interacts with the [AuthRepository] to perform the login
/// operation and retrieve the [User] entity.
///
/// The [Login] class requires an instance of [AuthRepository] to be passed
/// to its constructor.
///
/// Example usage:
/// ```dart
/// final loginUseCase = Login(authRepository);
/// final user = await loginUseCase.call(email, password);
/// ```
///
/// Methods:
/// - `Future<User> call(String email, String password)`: Performs the login
///   operation with the provided email and password, and returns a [User]
///   entity.
///
/// See also: [AuthRepository], [User]
///
/// Note: This class is a use case, and should not contain any business logic.
/// It should only interact with the repository to perform the required
/// operations.
class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(
          message: "Invalid email or password",
          exceptionMessage: e.toString()));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class UpdateUsername {
  final AuthRepository repository;

  UpdateUsername(this.repository);

  Future<Either<Failure, User>> call(String name, String id) async {
    try {
      final user = await repository.updateUsername(name, id);
      return right(user);
    } catch (e) {
      return left(VailditonFailure(message: e.toString()));
    }
  }
}

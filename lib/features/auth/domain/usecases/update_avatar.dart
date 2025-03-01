import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:task_app/core/common/failure.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class UpdateAvatar {
  final AuthRepository repository;

  UpdateAvatar(this.repository);

  Future<Either<Failure, User>> call(Uint8List image) async {
    try {
      final user = await repository.updateAvatar(image);
      return Right(user);
    } catch (e) {
      return Left(
        VailditonFailure(
          message: 'Invalid image $e',
        ),
      );
    }
  }
}

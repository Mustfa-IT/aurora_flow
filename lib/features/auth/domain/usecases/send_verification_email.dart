import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class SendVerificationEmail {
  final AuthRepository repository;

  SendVerificationEmail(this.repository);

  Future<void> call(String email) async {
    return await repository.sendVerificationEmail(email);
  }
}

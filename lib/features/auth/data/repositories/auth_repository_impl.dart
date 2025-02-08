import 'package:task_app/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    // Attempt login using the remote data source (PocketBase).
    final userModel = await remoteDataSource.login(email, password);

    return userModel;
  }
}

import 'package:task_app/features/home/data/data_sources/project_remote_source.dart';
import 'package:task_app/features/home/domain/entities/project.dart';
import 'package:task_app/features/home/domain/repository/project_repo.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Project>?> getProjects() async {
    return remoteDataSource.fetchProjects();
  }

  @override
  Future<Project?> getProject(String id) async {
    return await remoteDataSource.getProject(id);
  }

  @override
  Future<Project> createProject(
      String name, String desdescription, String owner) async {
    final data = {
      "name": name,
      "description": desdescription,
      "owner": owner,
    };
    print(data);
    return await remoteDataSource.createProject(data);
  }

  @override
  Future<Project> updateProject(
      String id, String name, String description, String owner) async {
    final data = {
      "name": name,
      "description": description,
      "owner": owner,
    };
    return await remoteDataSource.updateProject(id, data);
  }

  @override
  Future<void> deleteProject(String id) async {
    return await remoteDataSource.deleteProject(id);
  }

  @override
  Future<void> onProjectUpdates(String id, Function callBack) async {
    return await remoteDataSource.onProjectUpdate(id, callBack);
  }

  @override
  Future<void> onProjectsUpdates(callBack) async {
    return await remoteDataSource.onProjectsUpdates(callBack);
  }
}

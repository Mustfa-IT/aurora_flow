import 'package:task_app/features/home/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>?> getProjects();
  Future<Project?> getProject(String id);
  Future<Project> createProject(String name, String description, String owner);
  Future<Project> updateProject(
      String id, String name, String description, String owner);
  Future<void> deleteProject(String id);
  Future<void> onProjectUpdates(String id, Function callBack);

  Future<void> onProjectsUpdates(callBack);
}

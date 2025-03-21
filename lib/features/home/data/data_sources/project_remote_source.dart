import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/home/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>?> fetchProjects();
  Future<ProjectModel?> getProject(String id);
  Future<ProjectModel> createProject(Map<String, dynamic> projectData);
  Future<ProjectModel> updateProject(
      String id, Map<String, dynamic> projectData);
  Future<void> deleteProject(String id);
  Future<void> onProjectUpdate(String id, Function callBack);
  Future<void> onProjectsUpdates(Function callBack);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final PocketBase pocketBase;

  ProjectRemoteDataSourceImpl({required this.pocketBase});

  @override
  Future<List<ProjectModel>?> fetchProjects() async {
    try {
      final records = await pocketBase.collection('projects').getFullList();
      return records
          .map((record) => ProjectModel.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProjectModel?> getProject(String id) async {
    try {
      final record = await pocketBase.collection('projects').getOne(id);
      return ProjectModel.fromJson(record.toJson());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProjectModel> createProject(Map<String, dynamic> projectData) async {
    final record =
        await pocketBase.collection('projects').create(body: projectData);
    return ProjectModel.fromJson(record.toJson());
  }

  @override
  Future<ProjectModel> updateProject(
      String id, Map<String, dynamic> projectData) async {
    final record =
        await pocketBase.collection('projects').update(id, body: projectData);
    return ProjectModel.fromJson(record.toJson());
  }

  @override
  Future<void> deleteProject(String id) async {
    await pocketBase.collection('projects').delete(id);
  }

  @override
  Future<void> onProjectUpdate(String projectId, Function callBack) async {
    // Subscribe to changes only in the specified record
    await pocketBase.collection('projects').subscribe(
      projectId,
      (e) {
        callBack(ProjectModel.fromJson(e.record!.toJson()));
      },
    );
  }

  @override
  Future<void> onProjectsUpdates(Function callBack) async {
    print("Register Updates For projects");
    await pocketBase.collection('projects').subscribe("*", (e) {
      callBack();
    });
  }
}

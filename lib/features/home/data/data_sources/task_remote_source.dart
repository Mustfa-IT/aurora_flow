
import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/home/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks();
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask(Map<String, dynamic> taskData);
  Future<TaskModel> updateTask(String id, Map<String, dynamic> taskData);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final PocketBase pocketBase;

  TaskRemoteDataSourceImpl({required this.pocketBase});

  @override
  Future<List<TaskModel>> fetchTasks() async {
    final records = await pocketBase.collection('tasks').getFullList();
    return records.map((record) => TaskModel.fromJson(record.toJson())).toList();
  }

  @override
  Future<TaskModel> getTask(String id) async {
    final record = await pocketBase.collection('tasks').getOne(id);
    return TaskModel.fromJson(record.toJson());
  }

  @override
  Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
    final record = await pocketBase.collection('tasks').create(body: taskData);
    return TaskModel.fromJson(record.toJson());
  }

  @override
  Future<TaskModel> updateTask(String id, Map<String, dynamic> taskData) async {
    final record = await pocketBase.collection('tasks').update(id, body: taskData);
    return TaskModel.fromJson(record.toJson());
  }

  @override
  Future<void> deleteTask(String id) async {
    await pocketBase.collection('tasks').delete(id);
  }
}
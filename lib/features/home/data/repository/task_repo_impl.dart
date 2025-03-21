import 'package:task_app/features/home/data/data_sources/task_remote_source.dart';
import 'package:task_app/features/home/domain/entities/task.dart';
import 'package:task_app/features/home/domain/repository/tasks_repo.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Task>> getTasks() async {
    return await remoteDataSource.fetchTasks();
  }

  @override
  Future<Task> getTask(String id) async {
    return await remoteDataSource.getTask(id);
  }

  @override
  Future<Task> createTask(Task task) async {
    final data = {
      "title": task.title,
      "description": task.description,
      "due_time": task.dueTime.toIso8601String(),
      "status": task.status,
      "assigned_to": task.assignedTo,
    };
    return await remoteDataSource.createTask(data);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final data = {
      "title": task.title,
      "description": task.description,
      "due_time": task.dueTime.toIso8601String(),
      "status": task.status,
      "assigned_to": task.assignedTo,
    };
    return await remoteDataSource.updateTask(task.id, data);
  }

  @override
  Future<void> deleteTask(String id) async {
    return await remoteDataSource.deleteTask(id);
  }
}
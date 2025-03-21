import 'package:task_app/features/home/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueTime,
    required super.status,
    required super.assignedTo,
    required super.created,
    required super.updated,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueTime: DateTime.parse(json['due_time']),
      status: json['status'] as String,
      assignedTo: List<String>.from(json['assigned_to'] ?? []),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_time': dueTime.toIso8601String(),
      'status': status,
      'assigned_to': assignedTo,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

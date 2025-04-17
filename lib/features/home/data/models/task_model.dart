import 'dart:convert';

import 'package:task_app/features/home/data/models/status_model.dart';
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

  factory TaskModel.fromJson(Map<String, dynamic> source) {
    print('From Json in TaskModel');
    return TaskModel(
      id: source['id'] as String,
      title: source['title'] as String,
      description: source['description'] as String,
      dueTime: DateTime.parse(source['due_time']),
      status: null,
      assignedTo: List<String>.from(source['assigned_to'] ?? []),
      created: DateTime.parse(source['created']),
      updated: DateTime.parse(source['updated']),
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

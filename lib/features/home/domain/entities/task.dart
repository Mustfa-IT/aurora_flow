
import 'package:task_app/features/home/domain/entities/status.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueTime;
  final Status? status;
  final List<String> assignedTo;
  final DateTime created;
  final DateTime updated;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueTime,
    required this.status,
    required this.assignedTo,
    required this.created,
    required this.updated,
  });
}


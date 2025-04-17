import 'package:task_app/features/home/domain/entities/task.dart';

class Category {
  final String id;
  final String name;
  final int position;
  final int color;
  final int icon;
  final List<Task> tasks;
  final DateTime created;
  final DateTime updated;

  Category({
    required this.id,
    required this.name,
    required this.position,
    required this.color,
    required this.icon,
    required this.tasks,
    required this.created,
    required this.updated,
  });
}

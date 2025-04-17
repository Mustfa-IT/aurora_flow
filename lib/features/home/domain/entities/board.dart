import 'package:task_app/features/home/domain/entities/category.dart';

class Board {
  final String id;
  final String project;
  final List<Category> categories;
  final DateTime created;
  final DateTime updated;

  Board({
    required this.id,
    required this.project,
    required this.categories,
    required this.created,
    required this.updated,
  });
}

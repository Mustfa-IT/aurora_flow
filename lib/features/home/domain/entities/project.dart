import 'package:task_app/features/home/domain/entities/board.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String owner;
  final Board board;
  final DateTime created;
  final DateTime updated;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.board,
    required this.created,
    required this.updated,
  });
}

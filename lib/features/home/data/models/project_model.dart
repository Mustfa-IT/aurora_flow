import 'package:task_app/features/home/domain/entities/project.dart';
class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.owner,
    required super.board,
    required super.created,
    required super.updated,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      owner: json['owner'] as String,
      board: json['board'] as String,
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner': owner,
      'board': board,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}
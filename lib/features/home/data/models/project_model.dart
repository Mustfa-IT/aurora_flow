import 'dart:convert';

import 'package:task_app/features/home/data/models/board_model.dart';
import 'package:task_app/features/home/domain/entities/board.dart';
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

  factory ProjectModel.fromJson(Map<String, dynamic> source) {
    final boardMap = source['expand']['board'] as Map<String, dynamic>;
    print("From Json Project");
    return ProjectModel(
      id: source['id'] as String,
      name: source['name'] as String,
      description: source['description'] as String,
      owner: source['owner'] as String,
      board: BoardModel.fromMap(boardMap),
      created: DateTime.parse(source['created']),
      updated: DateTime.parse(source['updated']),
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

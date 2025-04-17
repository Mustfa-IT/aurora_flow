// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:task_app/features/home/data/models/category_model.dart';
import 'package:task_app/features/home/data/models/project_model.dart';

import 'package:task_app/features/home/domain/entities/board.dart';

class BoardModel extends Board {
  BoardModel({
    required super.id,
    required super.project,
    required super.categories,
    required super.updated,
    required super.created,
  });

  BoardModel copyWith({
    String? id,
    String? project,
    List<CategoryModel>? categories,
    DateTime? updated,
    DateTime? created,
  }) {
    return BoardModel(
      id: id ?? this.id,
      project: project ?? this.project,
      categories: categories ?? this.categories,
      updated: updated ?? this.updated,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project': project,
      'categories': categories,
      'updated': updated.millisecondsSinceEpoch,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    final catList = <CategoryModel>[];
    if (map['expand'] != null && map['expand']['categories'] != null) {
      catList.addAll(
        (map['expand']['categories'] as List).map<CategoryModel>((item) {
          return CategoryModel.fromMap(item);
        }),
      );
    } else {
      catList.addAll(
        (map['categories'] as List).map<CategoryModel>((item) {
          return CategoryModel.fromJson(item);
        }),
      );
    }
    print("From Json BoardModel");
    return BoardModel(
      id: map['id'] as String,
      project: map['project'] as String,
      categories: catList,
      updated: DateTime.parse(map['updated']),
      created: DateTime.parse(map['created']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BoardModel.fromJson(Map<String, dynamic> source) =>
      BoardModel.fromMap(source);

  @override
  String toString() {
    return 'BoardModel(id: $id, project: $project, categories: $categories, updated: $updated, created: $created)';
  }

  @override
  bool operator ==(covariant BoardModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.project == project &&
        listEquals(other.categories, categories) &&
        other.updated == updated &&
        other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        project.hashCode ^
        categories.hashCode ^
        updated.hashCode ^
        created.hashCode;
  }
}

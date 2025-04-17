import 'package:task_app/features/home/data/models/task_model.dart';
import 'package:task_app/features/home/domain/entities/category.dart';
import 'dart:convert';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.position,
    required super.color,
    required super.icon,
    required super.tasks,
    required super.created,
    required super.updated,
  });
  Category copyWith({
    String? id,
    String? name,
    int? position,
    int? color,
    int? icon,
    List<TaskModel>? tasks,
    DateTime? created,
    DateTime? updated,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      tasks: tasks ?? this.tasks,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'position': position,
      'tasks': tasks,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    print('From Category Model');
    final taskList = <TaskModel>[];
    if (map['expand'] != null && map['expand']['tasks'] != null) {
      taskList.addAll(
        (map['expand']['tasks'] as List).map<TaskModel>((item) {
          return TaskModel.fromJson(item);
        }),
      );
    } else {
      // taskList.addAll(
      //   (map['categories'] as List).map<TaskModel>((item) {
      //     return TaskModel.fromJson(item);
      //   }),
      // );
    }
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      position: map['position'] as int,
      color: map['color'] as int,
      icon: map['icon'] as int,
      tasks: taskList,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> source) =>
      CategoryModel.fromMap(source);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, position: $position, tasks: $tasks, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.position == position &&
        other.created == created &&
        other.updated == updated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        position.hashCode ^
        tasks.hashCode ^
        created.hashCode ^
        updated.hashCode;
  }
}

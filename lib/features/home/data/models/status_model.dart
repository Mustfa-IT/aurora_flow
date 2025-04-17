// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:task_app/features/home/domain/entities/status.dart';

class StatusModel extends Status {
  StatusModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.created,
    required super.updated,
  });

  StatusModel copyWith({
    String? id,
    String? name,
    String? createdBy,
    DateTime? created,
    DateTime? updated,
  }) {
    return StatusModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      id: map['id'] as String,
      name: map['name'] as String,
      createdBy: map['createdBy'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(Map<String, dynamic> source) =>
      StatusModel.fromMap(source);

  @override
  String toString() {
    return 'StatusModel(id: $id, name: $name, createdBy: $createdBy, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(covariant StatusModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.createdBy == createdBy &&
        other.created == created &&
        other.updated == updated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        createdBy.hashCode ^
        created.hashCode ^
        updated.hashCode;
  }
}

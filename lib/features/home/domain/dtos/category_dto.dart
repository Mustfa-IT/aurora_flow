import 'package:flutter/material.dart';
import 'package:task_app/features/home/domain/entities/task.dart';

class CategoryDto {
  final String name;
  final Color color;
  final List<Task> tasks;

  const CategoryDto({
    required this.name,
    required this.color,
    required this.tasks,
  });
}

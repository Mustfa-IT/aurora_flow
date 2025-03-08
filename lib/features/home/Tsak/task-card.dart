
import 'package:flutter/material.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onAssign;

  TaskCard({required this.task, required this.onAssign});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(task.title),
        trailing: IconButton(
          icon: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 16),
          ),
          onPressed: onAssign,
        ),
      ),
    );
  }
}

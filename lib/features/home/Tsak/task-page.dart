import 'package:flutter/material.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/home/Tsak/add-section.dart';
import 'package:task_app/features/home/Tsak/kanban.dart';
import 'package:task_app/features/home/Tsak/top-bar-task.dart';
import 'package:task_app/features/home/view/widget/profile_drawer.dart';




class UserModel {
  final String username;
  final String imageUrl;

  UserModel({required this.username, required this.imageUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => username.hashCode ^ imageUrl.hashCode;
}

/// Task model with counter data and a list of assigned users.
class Task {
  String title;
  String description;
  DateTime? dueDate;
  List<String> tags;
  List<UserModel> assignedUsers;
  int elapsedSeconds; // Timer counter

  Task({
    required this.title,
    this.description = '',
    this.dueDate,
    this.tags = const [],
    this.assignedUsers = const [],
    this.elapsedSeconds = 0,
  });
}

class ColumnModel {
  String title;
  List<Task> tasks;
  final Color color;
  Color headerColor;
  IconData icon;

  ColumnModel({
    required this.title,
    required this.tasks,
    required this.color,
    required this.headerColor,
    required this.icon,
  });
}

class DraggedTaskData {
  final int fromColumn;
  final Task task;
  DraggedTaskData({required this.fromColumn, required this.task});
}

class TaskPage extends StatefulWidget {
  final User user;
  const TaskPage({super.key, required this.user});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Color backgroundColor = Colors.blueGrey;

  List<ColumnModel> columns = [
    ColumnModel(
      title: "Open",
      tasks: [],
      color: Colors.white,
      headerColor: Colors.cyan,
      icon: Icons.lightbulb_outline,
    ),
    ColumnModel(
      title: "In Progress",
      tasks: [],
      color: Colors.white,
      headerColor: Colors.blue,
      icon: Icons.autorenew,
    ),
    ColumnModel(
      title: "Done",
      tasks: [],
      color: Colors.white,
      headerColor: Colors.deepPurple,
      icon: Icons.check_circle,
    ),
  ];

  void _addTask(int columnIndex, String taskTitle) {
    if (taskTitle.trim().isNotEmpty) {
      setState(() {
        columns[columnIndex].tasks.add(Task(title: taskTitle));
      });
    }
  }

  void _addColumn(String columnTitle) {
    if (columnTitle.trim().isNotEmpty) {
      setState(() {
        columns.add(
          ColumnModel(
            title: columnTitle,
            tasks: [],
            color: Colors.white,
            headerColor: Colors.green,
            icon: Icons.fiber_new_outlined,
          ),
        );
      });
    }
  }

  void _onReorderColumn(int oldIndex, int newIndex) {
    if (oldIndex >= columns.length || newIndex > columns.length - 1) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final movedColumn = columns.removeAt(oldIndex);
      columns.insert(newIndex, movedColumn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfileDrawer(
        user: widget.user,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          TopBarTask(user: widget.user),
          Expanded(
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              onReorder: _onReorderColumn,
              buildDefaultDragHandles: false,
              itemCount: columns.length + 1,
              itemBuilder: (context, index) {
                if (index < columns.length) {
                  return Container(
                    key: ValueKey("column_$index"),
                    margin: EdgeInsets.only(right: 2),
                    child: KanbanColumnWidget(
                      column: columns[index],
                      columnIndex: index,
                      onAddTask: _addTask,
                      onTaskDropped: (toColumnIndex, draggedData) {
                        setState(() {
                          columns[draggedData.fromColumn]
                              .tasks
                              .remove(draggedData.task);
                          columns[toColumnIndex].tasks.add(draggedData.task);
                        });
                      },
                      onUpdate: () {
                        setState(() {});
                      },
                      // تمرير دالة تُعيد القائمة الحالية للأقسام
                      getCurrentColumns: () => columns,
                      // دالة نقل المهمة عند اختيار السكشن المناسب
                      onMoveTask: (Task task, String selectedSection) {
                        setState(() {
                          // إزالة المهمة من القسم الحالي
                          for (var col in columns) {
                            if (col.tasks.contains(task)) {
                              col.tasks.remove(task);
                              break;
                            }
                          }
                          // إضافة المهمة إلى القسم الذي عنوانه يطابق selectedSection
                          for (var col in columns) {
                            if (col.title == selectedSection) {
                              col.tasks.add(task);
                              break;
                            }
                          }
                        });
                      },
                    ),
                  );
                } else {
                  return Container(
                    key: ValueKey("add_column"),
                    margin: EdgeInsets.only(right: 8),
                    child: AddColumnWidget(
                      onAddColumn: (newColumnTitle) {
                        _addColumn(newColumnTitle);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}










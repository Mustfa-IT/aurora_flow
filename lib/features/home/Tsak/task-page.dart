import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/home/Tsak/add-section.dart';
import 'package:task_app/features/home/Tsak/kanban.dart';
import 'package:task_app/features/home/Tsak/top-bar-task.dart';
import 'package:task_app/features/home/domain/entities/category.dart';
import 'package:task_app/features/home/domain/entities/task.dart';
import 'package:task_app/features/home/view/bloc/project_bloc.dart';
import 'package:task_app/features/home/view/widget/profile_drawer.dart';
import 'package:task_app/injection_container.dart';

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

  List<Category> columns = [];

  void _addTask(int columnIndex, String taskTitle) {
    if (taskTitle.trim().isNotEmpty) {
      setState(() {
        // columns[columnIndex].tasks.add(Task(title: taskTitle));
      });
    }
  }

  void _addColumn(String columnTitle) {
    if (columnTitle.trim().isNotEmpty) {
      setState(() {
        // columns.add(
        //   ColumnModel(
        //     title: columnTitle,
        //     tasks: [],
        //     color: Colors.white,
        //     headerColor: Colors.green,
        //     icon: Icons.fiber_new_outlined,
        //   ),
        // );
      });
    }
  }

  void _onReorderColumn(int oldIndex, int newIndex) {
    setState(() {
      // Skip if user tries to reorder the AddColumnWidget itself
      if (oldIndex == columns.length) return;

      // If dropped beyond the last column, clamp to the last index
      if (newIndex >= columns.length) {
        newIndex = columns.length - 1;
      }

      final movedColumn = columns.removeAt(oldIndex);
      columns.insert(newIndex, movedColumn);
    });
  }

  @override
  void initState() {
    sl<ProjectBloc>().add(RequestProjectsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ProfileDrawer(
        user: widget.user,
      ),
      backgroundColor: backgroundColor,
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return CircularProgressIndicator();
          } else if (state is GetProjectsSuccess ||
              state is ProjectsChanged ||
              state is CurrentProjectChanged) {
            columns = state.currentProject!.board.categories;
            return Column(
              children: [
                TopBarTask(
                  user: widget.user,
                  currentProject: state.currentProject!,
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    onReorder: _onReorderColumn,
                    buildDefaultDragHandles: false,
                    itemCount: columns.length + 1,
                    itemBuilder: (context, index) {
                      if (index < columns.length) {
                        return Container(
                          key: ValueKey(columns[index]),
                          margin: EdgeInsets.only(right: 2),
                          child: KanbanColumnWidget(
                            category: columns[index],
                            columnIndex: index,
                            onAddTask: _addTask,
                            onTaskDropped: (toColumnIndex, draggedData) {
                              setState(() {
                                columns[draggedData.fromColumn]
                                    .tasks
                                    .remove(draggedData.task);
                                columns[toColumnIndex]
                                    .tasks
                                    .add(draggedData.task);
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
                                  if (col.name == selectedSection) {
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
            );
          }
          return Text("NO data");
        },
      ),
    );
  }
}

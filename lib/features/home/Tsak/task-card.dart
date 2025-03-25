
import 'package:flutter/material.dart';
import 'package:task_app/features/home/Tsak/assign-users.dart';
import 'package:task_app/features/home/Tsak/task-detail.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';
import 'package:task_app/features/home/Tsak/timer.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onAssign;
  final List<ColumnModel> Function() getCurrentColumns;
  final Function(Task task, String selectedSection) onMoveTask;

  const TaskCard({
    super.key,
    required this.task,
    required this.onAssign,
    required this.getCurrentColumns,
    required this.onMoveTask,
  });

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TimerController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController =
        TimerController(initialSeconds: widget.task.elapsedSeconds);
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              SizedBox(height: 12),
              Text(
                user.username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  Widget _buildDueStatus(DateTime? dueDate) {
    if (dueDate == null) return SizedBox.shrink();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = dueDateOnly.difference(today).inDays;

    String statusText;
    Color statusColor;

    if (difference < 0) {
      statusText = "Overdue";
      statusColor = Colors.red;
    } else if (difference == 0) {
      statusText = "Due Today";
      statusColor = const Color.fromARGB(255, 251, 138, 1);
    } else {
      statusText = "Ends in $difference days";
      statusColor = Colors.blue;
    }

    return Row(
      children: [
        Icon(Icons.info, color: statusColor, size: 16),
        const SizedBox(width: 4),
        Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TaskDetailPopup(
            task: widget.task,
            timerController: _timerController,
            onClose: () => Navigator.of(context).pop(),
            onSave: () {
              setState(() {
                // TODO: After saving changes, call the backend API to update the task details.
                // This ensures that the changes are persisted on the server.
              });
            },
            sections: widget.getCurrentColumns(),
            onMoveTask: (selectedSection) {
              widget.onMoveTask(widget.task, selectedSection);
            },
          ),
        );
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Text(
                widget.task.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Task Description
              if (widget.task.description.isNotEmpty)
                Text(
                  widget.task.description,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 0, 28, 41),
                  ),
                ),
              const SizedBox(height: 8),
              // Due Date and Status
              if (widget.task.dueDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Due: ${widget.task.dueDate!.year}-${widget.task.dueDate!.month}-${widget.task.dueDate!.day}",
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 0, 19, 28),
                      ),
                    ),
                    _buildDueStatus(widget.task.dueDate),
                  ],
                ),
              const SizedBox(height: 8),
              // Tags
              if (widget.task.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: widget.task.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: TextStyle(fontSize: 10),
                          ),
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 8),
              // Assigned Users
              if (widget.task.assignedUsers.isNotEmpty ||
                  widget.task.assignedUsers.isEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...widget.task.assignedUsers.map((user) {
                      return GestureDetector(
                        onTap: () => _showUserDetails(user),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(user.imageUrl),
                            ),
                            SizedBox(height: 4),
                            Text(
                              user.username,
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    GestureDetector(
                      onTap: () async {
                        final List<UserModel>? selected =
                            await showDialog<List<UserModel>>(
                          context: context,
                          builder: (context) => AssignUsersDialog(
                            initialSelected: widget.task.assignedUsers,
                          ),
                        );
                        if (selected != null) {
                          setState(() {
                            widget.task.assignedUsers = selected;
                            // TODO: Update the backend with the new assigned users.
                            // This may involve an API call to update the task details on the server.
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person_add,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              // Timer Display
              ValueListenableBuilder<int>(
                valueListenable: _timerController.elapsedSeconds,
                builder: (context, seconds, _) {
                  if (seconds > 0) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: _timerController.isRunning
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            "Timer: ${_timerController.formattedTime}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_app/features/home/Tsak/assign-users.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';
import 'package:task_app/features/home/Tsak/timer.dart';

/// Popup for task details.
class TaskDetailPopup extends StatefulWidget {
  final Task task;
  final TimerController timerController;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final Function(String)? onMoveTask;
  final List<ColumnModel>? sections;

  const TaskDetailPopup({
    Key? key,
    required this.task,
    required this.timerController,
    required this.onClose,
    required this.onSave,
    this.onMoveTask,
    this.sections,
  }) : super(key: key);

  @override
  _TaskDetailPopupState createState() => _TaskDetailPopupState();
}

class _TaskDetailPopupState extends State<TaskDetailPopup>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  List<UserModel> _assignedUsers = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.dueDate;
    _assignedUsers = List.from(widget.task.assignedUsers);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      widget.timerController.toggle();
    });
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? now),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _openAssignUsersDialog() async {
    final List<UserModel>? selected = await showDialog<List<UserModel>>(
      context: context,
      builder: (context) => AssignUsersDialog(initialSelected: _assignedUsers),
    );
    if (selected != null) {
      setState(() {
        _assignedUsers = selected;
        // TODO: After selecting users, call the backend API to update the task's assigned users.
        // This might involve sending the updated list to a server.
      });
    }
  }

  Future<void> _openMoveTaskDialog() async {
    List<ColumnModel> sections = widget.sections ?? [];
    String? selectedSection = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Move Task to Section"),
          children: sections
              .map(
                (section) => SimpleDialogOption(
                  onPressed: () {
                    // TODO: When moving the task, call the backend API to update the task's section.
                    // Ensure that the server is informed about the new section assignment.
                    Navigator.pop(context, section.title);
                  },
                  child: Text(section.title),
                ),
              )
              .toList(),
        );
      },
    );
    if (selectedSection != null) {
      widget.onMoveTask?.call(selectedSection);
      Navigator.of(context).pop();
    }
  }

  void _saveChanges() {
    widget.task.title = _titleController.text;
    widget.task.description = _descriptionController.text;
    widget.task.dueDate = _selectedDate;
    widget.task.assignedUsers = List.from(_assignedUsers);
    widget.task.elapsedSeconds = widget.timerController.elapsedSeconds.value;
    // TODO: Call the backend API to save the updated task details.
    // This is where you integrate with your backend to persist changes.
    widget.onSave();
    Navigator.of(context).pop();
  }

  Widget _buildDueStatus(DateTime? dueDate) {
    if (dueDate == null) return const SizedBox.shrink();
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
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      elevation: 2,
    );

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Task Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: "Close",
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: widget.onClose,
                    )
                  ],
                ),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Section (Title and Description)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Task Title",
                              labelStyle: const TextStyle(color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                              labelStyle: const TextStyle(color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueGrey.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Additional Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Assigned Users: ${_assignedUsers.map((u) => u.username).join(", ")}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                _buildDueStatus(_selectedDate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right Section (Buttons)
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            style: buttonStyle,
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
                            label: Text(
                              _selectedDate != null
                                  ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
                                  : "Pick Date",
                            ),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 1),
                          ElevatedButton.icon(
                            style: buttonStyle.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                widget.timerController.isRunning ? Colors.redAccent : Colors.green,
                              ),
                            ),
                            onPressed: _toggleTimer,
                            icon: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.timer, color: Colors.white),
                                if (widget.timerController.isRunning)
                                  const Icon(Icons.pause, size: 12, color: Colors.white),
                              ],
                            ),
                            label: ValueListenableBuilder<int>(
                              valueListenable: widget.timerController.elapsedSeconds,
                              builder: (context, seconds, _) {
                                return Text(widget.timerController.formattedTime);
                              },
                            ),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 1),
                          ElevatedButton.icon(
                            style: buttonStyle,
                            onPressed: _openMoveTaskDialog,
                            icon: const Icon(Icons.drive_file_move_outlined, color: Colors.white),
                            label: const Text("Move Task"),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 1),
                          ElevatedButton.icon(
                            style: buttonStyle,
                            onPressed: _openAssignUsersDialog,
                            icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                            label: const Text("Assign Users"),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 1),
                          ElevatedButton.icon(
                            style: buttonStyle.copyWith(
                              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.delete_outline, color: Colors.white),
                            label: const Text("Delete Task"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: buttonStyle,
                    onPressed: _saveChanges,
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
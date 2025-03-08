import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/features/home/Tsak/task-card.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';
import 'package:task_app/features/home/view/widget/hoverIcon_button.dart';

class KanbanColumnWidget extends StatefulWidget {
  final ColumnModel column;
  final int columnIndex;
  final Function(int, String) onAddTask;
  final Function(int, DraggedTaskData) onTaskDropped;
  final VoidCallback onUpdate;

  KanbanColumnWidget({
    required this.column,
    required this.columnIndex,
    required this.onAddTask,
    required this.onTaskDropped,
    required this.onUpdate,
  });

  @override
  _KanbanColumnWidgetState createState() => _KanbanColumnWidgetState();
}

class _KanbanColumnWidgetState extends State<KanbanColumnWidget> {
  bool isAddingTask = false;
  bool isEditingTitle = false;
  late TextEditingController taskInputController;
  late TextEditingController titleEditingController;
  late FocusNode taskFocusNode;
  late FocusNode titleFocusNode;
  bool _isDragAreaHovered = false;
  bool _isGroupHovered = false;

  @override
  void initState() {
    super.initState();
    taskInputController = TextEditingController();
    titleEditingController = TextEditingController(text: widget.column.title);
    taskFocusNode = FocusNode();
    titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    taskInputController.dispose();
    titleEditingController.dispose();
    taskFocusNode.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  void _saveTitle() {
    setState(() {
      widget.column.title = titleEditingController.text.trim();
      isEditingTitle = false;
    });
    widget.onUpdate();
  }

  void _submitTask() {
    String newTaskText = taskInputController.text.trim();
    if (newTaskText.isNotEmpty) {
      widget.onAddTask(widget.columnIndex, newTaskText);
    }
    taskInputController.clear();
    setState(() {
      isAddingTask = false;
    });
  }

  void _showColumnSettingsDialog() {
    List<Color> availableHeaderColors = [
      Colors.red,
      Colors.deepOrange,
      Colors.amber,
      Colors.lime,
      Colors.green,
      Colors.blueGrey,
      Colors.deepPurple,
      Colors.purple,
      Colors.blue,
      Colors.pinkAccent,
    ];

    List<IconData> availableIcons = [
      Icons.view_kanban,
      Icons.task_alt,
      Icons.check_box_outline_blank,
      Icons.folder_open,
      Icons.calendar_today,
      Icons.access_time,
      Icons.note_alt,
      Icons.search,
      Icons.notifications_none,
      Icons.add_circle_outline,
      Icons.edit_outlined,
      Icons.delete_outline,
      Icons.share_outlined,
      Icons.insert_drive_file_outlined,
      Icons.chat_bubble_outline,
      Icons.group_outlined,
      Icons.person_outline,
      Icons.settings_outlined,
      Icons.lightbulb_outline,
      Icons.archive_outlined,
      Icons.link,
      Icons.build_outlined,
      Icons.support_agent_outlined,
      Icons.work_outline,
    ];

    Color selectedColor = widget.column.headerColor;
    IconData selectedIcon = widget.column.icon;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit Section",
                  style: Theme.of(context).textTheme.titleLarge),
              content: Container(
                width: 300,
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Header Color:",
                          style: Theme.of(context).textTheme.titleMedium),
                      Wrap(
                        spacing: 8,
                        children: availableHeaderColors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Text("Select Icon:",
                          style: Theme.of(context).textTheme.titleMedium),
                      Wrap(
                        spacing: 8,
                        children: availableIcons.map((iconData) {
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                selectedIcon = iconData;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedIcon == iconData
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(iconData, size: 24),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.column.headerColor = selectedColor;
                      widget.column.icon = selectedIcon;
                    });
                    widget.onUpdate();
                    Navigator.of(context).pop();
                  },
                  child: Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: widget.column.color,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: widget.column.headerColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(2)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showColumnSettingsDialog,
                        child: Icon(
                          widget.column.icon,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: isEditingTitle
                              ? Focus(
                                  key: ValueKey("editTitle"),
                                  focusNode: titleFocusNode,
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus && isEditingTitle) {
                                      _saveTitle();
                                    }
                                  },
                                  child: TextField(
                                    controller: titleEditingController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 4),
                                      border: OutlineInputBorder(),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onEditingComplete: _saveTitle,
                                  ),
                                )
                              : GestureDetector(
                                  key: ValueKey("displayTitle"),
                                  onTap: () {
                                    setState(() {
                                      isEditingTitle = true;
                                    });
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      FocusScope.of(context)
                                          .requestFocus(titleFocusNode);
                                    });
                                  },
                                  child: Text(
                                    widget.column.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                        ),
                      ),
                      Row(
                        children: [
                          ReorderableDragStartListener(
                            index: widget.columnIndex,
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isDragAreaHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isDragAreaHovered = false;
                                });
                              },
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: _isDragAreaHovered
                                    ? Icon(FontAwesomeIcons.handPaper,
                                        size: 25, color: Colors.white)
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _isGroupHovered = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _isGroupHovered = false;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.transparent,
                              child: _isGroupHovered
                                  ? HoverIconButton(
                                      tooltip: 'Section Options',
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.more_horiz_sharp,
                                        color: AppDesign.primaryText,
                                        size: 20,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DragTarget<DraggedTaskData>(
                    onWillAccept: (data) => true,
                    onAccept: (data) {
                      widget.onTaskDropped(widget.columnIndex, data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return ListView(
                        padding: EdgeInsets.all(8),
                        children: [
                          if (widget.column.tasks.isEmpty)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.task_alt,
                                      size: 70, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text(
                                    "No Task",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            for (var task in widget.column.tasks)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Draggable<DraggedTaskData>(
                                  data: DraggedTaskData(
                                      fromColumn: widget.columnIndex,
                                      task: task),
                                  feedback: Material(
                                    elevation: 6.0,
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 300),
                                      child:
                                          TaskCard(task: task, onAssign: () {}),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child:
                                        TaskCard(task: task, onAssign: () {}),
                                  ),
                                  child: TaskCard(task: task, onAssign: () {}),
                                ),
                              ),
                          ],
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: isAddingTask
                                ? Focus(
                                    key: ValueKey("addTask"),
                                    focusNode: taskFocusNode,
                                    onFocusChange: (hasFocus) {
                                      if (!hasFocus && isAddingTask) {
                                        _submitTask();
                                      }
                                    },
                                    child: TextField(
                                      controller: taskInputController,
                                      autofocus: true,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "Enter task title...",
                                        border: OutlineInputBorder(),
                                      ),
                                      onEditingComplete: _submitTask,
                                    ),
                                  )
                                : TextButton.icon(
                                    key: ValueKey("showAddTask"),
                                    onPressed: () {
                                      setState(() {
                                        isAddingTask = true;
                                      });
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        FocusScope.of(context)
                                            .requestFocus(taskFocusNode);
                                      });
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text("Add Task"),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
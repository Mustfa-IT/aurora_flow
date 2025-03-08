import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddColumnWidget extends StatefulWidget {
  final Function(String) onAddColumn;

  AddColumnWidget({required this.onAddColumn});

  @override
  _AddColumnWidgetState createState() => _AddColumnWidgetState();
}

class _AddColumnWidgetState extends State<AddColumnWidget> {
  bool isAdding = false;
  TextEditingController columnInputController = TextEditingController();
  FocusNode columnFocusNode = FocusNode();

  @override
  void dispose() {
    columnInputController.dispose();
    columnFocusNode.dispose();
    super.dispose();
  }

  void _submitColumn() {
    String newColumnTitle = columnInputController.text.trim();
    if (newColumnTitle.isNotEmpty) {
      widget.onAddColumn(newColumnTitle);
    }
    setState(() {
      isAdding = false;
      columnInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
          Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Section",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAdding = true;
                      Future.delayed(Duration(milliseconds: 100), () {
                        FocusScope.of(context).requestFocus(columnFocusNode);
                      });
                    });
                  },
                  child: Icon(Icons.add, size: 28, color: Colors.white),
                ),
              ],
            ),
          ),

         
          if (isAdding)
            Padding(
              padding: EdgeInsets.all(12),
              child: RawKeyboardListener(
                focusNode: columnFocusNode,
                onKey: (event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    _submitColumn();
                  }
                },
                child: TextField(
                  controller: columnInputController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter section name...",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => _submitColumn(),
                ),
              ),
            ),

         
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Members",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Invite"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


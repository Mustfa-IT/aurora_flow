
import 'package:flutter/material.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';


class AssignUsersDialog extends StatefulWidget {
  final List<UserModel> initialSelected;
  const AssignUsersDialog({Key? key, required this.initialSelected})
      : super(key: key);

  @override
  _AssignUsersDialogState createState() => _AssignUsersDialogState();
}

class _AssignUsersDialogState extends State<AssignUsersDialog> {
  // TODO: Replace the dummy data with real data fetched from a backend API or database.
  final List<UserModel> _allUsers = [
    UserModel(
        username: "Alice",
        imageUrl: "https://randomuser.me/api/portraits/women/1.jpg"),
    UserModel(
        username: "Bob",
        imageUrl: "https://randomuser.me/api/portraits/men/1.jpg"),
    UserModel(
        username: "Charlie",
        imageUrl: "https://randomuser.me/api/portraits/men/2.jpg"),
    UserModel(
        username: "Diana",
        imageUrl: "https://randomuser.me/api/portraits/women/2.jpg"),
    UserModel(
        username: "Eve",
        imageUrl: "https://randomuser.me/api/portraits/women/3.jpg"),
    UserModel(
        username: "Frank",
        imageUrl: "https://randomuser.me/api/portraits/men/3.jpg"),
  ];

  late List<UserModel> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 320,
        height: 400,
        child: Column(
          children: [
            Text(
              "Assign Users",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _allUsers.length,
                itemBuilder: (context, index) {
                  UserModel user = _allUsers[index];
                  bool isSelected = _selectedUsers.contains(user);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          // Ensure the user is not already selected before adding.
                          if (!_selectedUsers.contains(user)) {
                            _selectedUsers.add(user);
                          }
                        } else {
                          _selectedUsers.remove(user);
                        }
                      });
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        SizedBox(width: 10),
                        Text(user.username),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedUsers);
                },
                child: Text("Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
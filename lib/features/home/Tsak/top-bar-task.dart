import 'package:flutter/material.dart';
import 'package:task_app/core/config/config.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/home/domain/entities/project.dart';
import 'package:task_app/features/home/view/widget/hoverIcon_button.dart';
import 'package:task_app/features/home/view/widget/vertical-divider.dart';

class TopBarTask extends StatelessWidget {
  final User user;
  final Project currentProject;
  const TopBarTask({
    super.key,
    required this.user,
    required this.currentProject,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HoverIconButton(
            tooltip: 'Menu',
            onPressed: () {},
            child: Icon(Icons.menu,
                color: const Color.fromARGB(221, 48, 48, 48), size: 30),
          ),
          // TITLE
          Text(
            currentProject.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text("Share"),
              ),
              SizedBox(width: 20),
              VerticalDividerWidget(),
              HoverIconButton(
                tooltip: 'Group',
                onPressed: () {},
                child: Icon(Icons.group, color: Colors.black87, size: 30),
              ),
              SizedBox(width: 20),
              VerticalDividerWidget(),
              HoverIconButton(
                tooltip: 'Timer',
                onPressed: () {},
                child: Icon(Icons.timer, color: Colors.black87, size: 30),
              ),
              SizedBox(width: 20),
              HoverIconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                child: Icon(Icons.notifications_active,
                    color: Colors.black87, size: 30),
              ),
              SizedBox(width: 20),
              HoverIconButton(
                tooltip: 'My Task',
                onPressed: () {},
                child:
                    Icon(Icons.check_circle, color: Colors.black87, size: 30),
              ),
              SizedBox(width: 20),
              VerticalDividerWidget(),
              HoverIconButton(
                tooltip: 'Profile',
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${Config.pocketBaseUrl}/api/files/${user.collectionId}/${user.id}/${user.avatar}'),
                  radius: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

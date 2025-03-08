import 'package:flutter/material.dart';
import 'package:task_app/features/home/view/widget/hoverIcon_button.dart';
import 'package:task_app/features/home/view/widget/vertical-divider.dart';

class TopBarTask extends StatelessWidget {
  const TopBarTask({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.white70,
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
                tooltip: 'Add',
                onPressed: () {
                  
                },
                child: Icon(Icons.add, color: Colors.black87, size: 30),
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
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 20,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
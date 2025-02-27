import 'package:flutter/material.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/core/config/config.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/home/view/widget/hoverIcon-button.dart';


// =============================================
// Top Bar Widget مع تأثير hover للأيقونات
// =============================================
class TopBar extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final User user;
  const TopBar({Key? key, required this.onMenuPressed,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // ارتفاع الشريط العلوي
      color: Colors.transparent, // الشريط شفاف تماماً
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // أيقونة القائمة مع HoverIconButton
          HoverIconButton(
            tooltip: 'Menu',
            onPressed: onMenuPressed,
            child: Icon(Icons.menu, color: AppDesign.primaryText, size: 30),
          ),
          // صف الأيقونات مع HoverIconButton لكل منها
          Row(
            children: [
              HoverIconButton(
                tooltip: 'Timer',
                onPressed: () {},
                child: Icon(Icons.timer, color: AppDesign.primaryText, size: 30),
              ),
              SizedBox(width: 20),
              _verticalDivider(),
              HoverIconButton(
                tooltip: 'Group',
                onPressed: () {},
                child: Icon(Icons.group, color: AppDesign.primaryText, size: 30),
              ),
              SizedBox(width: 20),
              _verticalDivider(),
              HoverIconButton(
                tooltip: 'Add',
                onPressed: () {},
                child: Icon(Icons.add, color: AppDesign.primaryText, size: 30),
              ),
              SizedBox(width: 20),
              _verticalDivider(),
              HoverIconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                child: Icon(Icons.notifications_active, color: AppDesign.primaryText, size: 30),
              ),
              SizedBox(width: 20),
              _verticalDivider(),
              HoverIconButton(
                tooltip: 'My Task',
                onPressed: () {},
                child: Icon(Icons.check_circle, color: AppDesign.primaryText, size: 30),
              ),
              SizedBox(width: 20),
              _verticalDivider(),
              HoverIconButton(
                tooltip: 'Profile',
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage:  NetworkImage(
                          '${Config.pocketBaseUrl}/api/files/${user.collectionId}/${user.id}/${user.avatar}'),
                  radius: 18,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  // فاصل عمودي بين الأيقونات
  Widget _verticalDivider() {
    return Row(
      children: [
        SizedBox(width: 8),
        Container(
          height: 24,
          width: 1,
          color: AppDesign.primaryText,
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
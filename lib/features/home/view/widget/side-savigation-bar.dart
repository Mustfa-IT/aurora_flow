import 'package:flutter/material.dart';
import 'package:task_app/features/home/view/widget/app-design.dart';

// =============================================
// Side Navigation Bar Widget
// =============================================
// الشريط الجانبي الذي يحتوي على الشعار وباقي عناصر التنقل
class SideNavigationBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const SideNavigationBar({
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDesign.sidebarWidth,
      color: AppDesign.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          _buildNavItem(Icons.folder, 0, 'Projects'),
          _buildNavItem(Icons.search, 1, 'Search'),
          _buildNavItem(Icons.bar_chart, 2, 'Reports'),
        ],
      ),
    );
  }

  // شعار التطبيق مع تأثير ظل لتعزيز التصميم
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 2, 73, 145).withOpacity(0.6),
              spreadRadius: 5,
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Image.asset('assets/logo-image2.png', width: 60),
      ),
    );
  }

  // عنصر تنقل لكل أيقونة مع النص
  Widget _buildNavItem(IconData icon, int index, String label) {
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: selectedIndex == index
            ? Colors.black.withOpacity(0.2)
            : Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: selectedIndex == index
                    ? AppDesign.activeIconColor
                    : AppDesign.inactiveIconColor,
                size: 28),
            SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: selectedIndex == index
                        ? AppDesign.activeIconColor
                        : AppDesign.inactiveIconColor)),
          ],
        ),
      ),
    );
  }
}
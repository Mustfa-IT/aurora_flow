
// =============================================
// Sliding Menu Widget
// =============================================
// القائمة المنزلقة التي تظهر عند اختيار تبويب معين (مثل المشاريع)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/features/home/view/widget/data-models.dart';

class SlidingMenu extends StatelessWidget {
  final int selectedMenu;
  final List<Project> projects;
  final VoidCallback onClose;

  const SlidingMenu({
    required this.selectedMenu,
    required this.projects,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDesign.slidingMenuWidth,
      color: AppDesign.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Divider(height: 1, color: Colors.white12),
          Expanded(child: _buildMenuContent()),
        ],
      ),
    );
  }

  // رأس القائمة المنزلقة مع عنوانها وزر الإغلاق
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            _getTitle(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  // تحديد العنوان بناءً على التبويب المحدد
  String _getTitle() {
    switch (selectedMenu) {
      case 0:
        return 'Projects';
      case 1:
        return 'Search';
      case 2:
        return 'Reports';
      default:
        return '';
    }
  }

  // محتوى القائمة المنزلقة بناءً على التبويب
  Widget _buildMenuContent() {
    switch (selectedMenu) {
      case 0:
        return _buildProjectsContent();
      case 1:
        return _buildSearchContent();
      case 2:
        return _buildReportsContent();
      default:
        return Container();
    }
  }

  // محتوى تبويب المشاريع
  Widget _buildProjectsContent() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildMenuItem(Icons.add, 'Create Project'),
        _buildMenuItem(Icons.dashboard, 'Overview'),
        Divider(height: 24, color: Colors.white12),
        if (projects.isEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'You don’t have any projects yet.\nClick + to create or import projects.',
              style: TextStyle(color: AppDesign.inactiveIconColor, height: 1.5),
            ),
          ),
        ...projects
            .map((p) => ListTile(
                  title: Text(p.name, style: TextStyle(color: Colors.white)),
                  subtitle: Text(DateFormat.yMMMd().format(p.createdAt),
                      style: TextStyle(color: AppDesign.inactiveIconColor)),
                ))
            .toList(),
      ],
    );
  }

  // عنصر مشترك لقائمة العناصر في القائمة المنزلقة
  Widget _buildMenuItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }

  // محتوى تبويب البحث
  Widget _buildSearchContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: AppDesign.inactiveIconColor),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          _buildMenuItem(Icons.dashboard, 'Overview'),
        ],
      ),
    );
  }

  // محتوى تبويب التقارير
  Widget _buildReportsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(Icons.dashboard, 'Overview'),
          Divider(height: 24, color: Colors.white12),
          _buildReportButton('Daily Reports'),
          _buildReportButton('Weekly Reports'),
          _buildReportButton('Monthly Reports'),
        ],
      ),
    );
  }

  // زر لتحديد نوع التقرير
  Widget _buildReportButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white12),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
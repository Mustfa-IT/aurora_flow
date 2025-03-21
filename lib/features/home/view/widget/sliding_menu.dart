// =============================================
// Sliding Menu Widget
// =============================================
// القائمة المنزلقة التي تظهر عند اختيار تبويب معين (مثل المشاريع)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/home/domain/entities/project.dart';
import 'package:task_app/features/home/domain/repository/project_repo.dart';
import 'package:task_app/features/home/view/bloc/project_bloc.dart';
import 'package:task_app/injection_container.dart';

class SlidingMenu extends StatefulWidget {
  final int selectedMenu;
  final VoidCallback onClose;

  const SlidingMenu({
    super.key,
    required this.selectedMenu,
    required this.onClose,
  });

  @override
  State<SlidingMenu> createState() => _SlidingMenuState();
}

class _SlidingMenuState extends State<SlidingMenu> {
  List<Project>? projects;

  @override
  void initState() {
    sl<ProjectBloc>().add(RequestProjectsEvent());
    super.initState();
  }

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
          Expanded(child: _buildMenuContent(context)),
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
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  // تحديد العنوان بناءً على التبويب المحدد
  String _getTitle() {
    switch (widget.selectedMenu) {
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
  Widget _buildMenuContent(context) {
    switch (widget.selectedMenu) {
      case 0:
        return _buildProjectsContent(context);
      case 1:
        return _buildSearchContent();
      case 2:
        return _buildReportsContent();
      default:
        return Container();
    }
  }

  // محتوى تبويب المشاريع
  Widget _buildProjectsContent(context) {
    return BlocListener<ProjectBloc, ProjectState>(
      listener: (context, state) {
        print("Projects Changes" + state.projects.toString());
        setState(() {
          projects = state.projects;
        });
      },
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuItem(Icons.add, 'Create Project', onTap: () {
            createProjectCallback();
          }),
          _buildMenuItem(Icons.dashboard, 'Overview'),
          Divider(height: 24, color: Colors.white12),
          if (projects == null || projects!.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'You don’t have any projects yet.\nClick + to create or import projects.',
                style:
                    TextStyle(color: AppDesign.inactiveIconColor, height: 1.5),
              ),
            ),
          if (projects != null)
            ...projects!.map((p) => ListTile(
                  title: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => {
                        sl<ProjectBloc>()
                            .add(ChangeCurrentProjectEvent(id: p.id))
                      },
                      child:
                          Text(p.name, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  subtitle: Text(DateFormat.yMMMd().format(p.created),
                      style: TextStyle(color: AppDesign.inactiveIconColor)),
                )),
        ],
      ),
    );
  }

  // عنصر مشترك لقائمة العناصر في القائمة المنزلقة
  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: onTap,
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

  void createProjectCallback() {
    showDialog(
      context: context,
      builder: (context) {
        String projectName = '';
        String projectDescription = '';
        return AlertDialog(
          backgroundColor: AppDesign.sidebarBackground,
          title: Text(
            'Create Project',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  labelStyle: TextStyle(color: AppDesign.inactiveIconColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppDesign.inactiveIconColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  projectName = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  labelStyle: TextStyle(color: AppDesign.inactiveIconColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppDesign.inactiveIconColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  projectDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                if (projectName.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Project Name cannot be empty'),
                    ),
                  );
                  return;
                }

                // Check if the user is not null before creating the project
                final currentUser = sl<AuthBloc>().state.user;
                if (currentUser == null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not logged in')),
                  );
                  return;
                }

                sl.get<ProjectRepository>().createProject(
                      projectName,
                      projectDescription,
                      currentUser.id,
                    );
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

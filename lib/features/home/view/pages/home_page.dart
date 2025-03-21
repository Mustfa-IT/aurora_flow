import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/features/home/Tsak/task-page.dart';
import 'package:task_app/features/home/view/bloc/project_bloc.dart';
import 'package:task_app/features/home/view/widget/main_dashboard.dart';
import 'package:task_app/features/home/view/widget/profile_drawer.dart';
import 'package:task_app/features/home/view/widget/side_navigation_bar.dart';
import 'package:task_app/features/home/view/widget/sliding_menu.dart';
import 'package:task_app/features/home/view/widget/top_bar.dart';

// =============================================
// Home Page Widget
// =============================================
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  bool _showSlidingMenu = false;
  late String _time;
  late String _greeting;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthBloc>().state.user;
    _updateTime();
  }

  void _toggleSlidingMenu() {
    setState(() {
      _showSlidingMenu = !_showSlidingMenu;
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = DateFormat('h:mm a').format(now);
      _greeting = _getGreeting(now);
    });
    Future.delayed(Duration(seconds: 30), _updateTime);
  }

  String _getGreeting(DateTime time) {
    final hour = time.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    double leftWidth = AppDesign.sidebarWidth +
        (_showSlidingMenu ? AppDesign.slidingMenuWidth : 0);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthSessionActive) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        _user = state.user;
      },
      child: Scaffold(
        endDrawer: ProfileDrawer(
          user: _user!,
        ),
        body: Row(
          children: [
            Container(
              width: leftWidth,
              height: double.infinity,
              child: Stack(
                children: [
                  SideNavigationBar(
                    selectedIndex: _selectedTab,
                    onTabSelected: (index) {
                      setState(() {
                        _selectedTab = index;
                        _showSlidingMenu = true;
                      });
                    },
                  ),
                  if (_showSlidingMenu)
                    Positioned(
                        left: AppDesign.sidebarWidth,
                        top: 0,
                        bottom: 0,
                        child: SlidingMenu(
                          selectedMenu: _selectedTab,
                          onClose: () =>
                              setState(() => _showSlidingMenu = false),
                        )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 27, 46, 55),
                      Color.fromARGB(255, 27, 46, 55),
                      Color.fromARGB(255, 27, 46, 55),
                      Color.fromARGB(255, 27, 46, 55),
                    ],
                    stops: [0.0, 0.33, 0.66, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state.currentProject == null) {
                      return Column(
                        children: [
                          TopBar(
                            onMenuPressed: _toggleSlidingMenu,
                            user: _user!,
                          ),
                          Expanded(
                            child: MainDashboard(
                              userName: _user?.name ?? 'Guest',
                              timeString: _time,
                              greeting: _greeting,
                            ),
                          ),
                        ],
                      );
                    }

                    return TaskPage(
                      user: _user!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

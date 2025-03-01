import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/domain/entities/user.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/common/app-design.dart';
import 'package:task_app/features/home/view/widget/data_models.dart';
import 'package:task_app/features/home/view/widget/main_dashboard.dart';
import 'package:task_app/features/home/view/widget/profile_drawer.dart';
import 'package:task_app/features/home/view/widget/side_navigation_bar.dart';
import 'package:task_app/features/home/view/widget/sliding_menu.dart';
import 'package:task_app/features/home/view/widget/top_bar.dart';

// =============================================
// Home Page Widget
// =============================================
// الصفحة الرئيسية التي تجمع جميع المكونات مع شريط جانبي، قائمة منزلقة، وشريط علوي.
// كما تم إضافة EndDrawer لعرض نافذة منبثقة عند الضغط على صورة المستخدم (حيث يمكن وضع زر Logout).
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  bool _showSlidingMenu = false;
  late String _time;
  late String _greeting;

  // بيانات تجريبية للمستخدم والمشاريع؛ عدلها وفقاً للبيانات الحقيقية
  User? _user;
  final List<Project> _projects = [
    Project(id: '1', name: 'Project 1', createdAt: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthBloc>().state.user;
    _updateTime();
  }

  // دالة تبديل القائمة المنزلقة
  void _toggleSlidingMenu() {
    setState(() {
      _showSlidingMenu = !_showSlidingMenu;
    });
  }

  // تحديث الوقت والترحيب كل 30 ثانية
  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = DateFormat('h:mm a').format(now);
      _greeting = _getGreeting(now);
    });
    Future.delayed(Duration(seconds: 30), _updateTime);
  }

  // تحديد نص الترحيب بناءً على الوقت الحالي
  String _getGreeting(DateTime time) {
    final hour = time.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    // حساب عرض القسم الأيسر بناءً على ظهور القائمة المنزلقة
    double leftWidth = AppDesign.sidebarWidth +
        (_showSlidingMenu ? AppDesign.slidingMenuWidth : 0);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // عند إصدار حالة انتهاء الجلسة، يعاد توجيه المستخدم إلى صفحة تسجيل الدخول.
        if (state is! AuthSessionActive) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        _user = state.user;
        print(state.user!.name);
      },
      child: Scaffold(
        // استخدام ProfileDrawer هنا كـ EndDrawer
        endDrawer: ProfileDrawer(
          user: _user!,
        ),
        body: Row(
          children: [
            // القسم الأيسر: الشريط الجانبي والقائمة المنزلقة
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
                        projects: _projects,
                        onClose: () => setState(() => _showSlidingMenu = false),
                      ),
                    ),
                ],
              ),
            ),
            // القسم الأيمن: تغليف بخلفية تدرج الألوان
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
                child: Column(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

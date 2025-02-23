import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/home/view/widget/app-design.dart';
import 'package:task_app/features/home/view/widget/hoverIcon-button.dart';

// // كلاس منفصل لعرض نافذة EndDrawer عند الضغط على صورة الحساب
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // زر إغلاق النافذة في أعلى اليمين
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HoverIconButton(
                  tooltip: "Close",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // مكان صورة الحساب واسم المستخدم والبريد والخطة
            // (سيقوم مبرمج الـBackend بجلبها من السيرفر لاحقاً)
            Center(
              child: Column(
                children: [
                  // صورة الحساب
                  // استبدل بـ NetworkImage أو AssetImage حسب الحاجة
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    // backgroundImage: NetworkImage(''), // مثال لإضافة الصورة
                  ),
                  const SizedBox(height: 30),
                  // اسم المستخدم
                  const Text(
                    'اسم المستخدم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // البريد الإلكتروني
                  const Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  // الخطة (مثال: Basic)
                  const Text(
                    'Basic',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // قائمة الخيارات
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Account
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: const Text('Account',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // نفّذ الإجراء المطلوب هنا
                      },
                      hoverColor: Colors.white24,
                    ),
                    const SizedBox(height: 20),
                    // Notifications
                    ListTile(
                      leading:
                          const Icon(Icons.notifications, color: Colors.white),
                      title: const Text('Notifications',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // نفّذ الإجراء المطلوب هنا
                      },
                      hoverColor: Colors.white24,
                    ),
                    const SizedBox(height: 20),
                    // My Team
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('My Team',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // نفّذ الإجراء المطلوب هنا
                      },
                      hoverColor: Colors.white24,
                    ),
                  ],
                ),
              ),
            ),

            // زر Logout
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () {
                  // إظهار رسالة تأكيد للمستخدم
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // إذا ضغط على No
                              Navigator.of(context).pop(); // إغلاق الـDialog
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // إذا ضغط على Yes
                              context
                                  .read<AuthBloc>()
                                  .add(AuthLogoutRequested());
                              Navigator.of(context).pop(); // إغلاق الـDialog
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.redAccent,
                  elevation: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

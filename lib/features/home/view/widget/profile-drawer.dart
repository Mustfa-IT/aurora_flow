import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/home/view/widget/app-design.dart';
import 'package:task_app/features/home/view/widget/hoverIcon-button.dart';


// كلاس منفصل لعرض نافذة EndDrawer عند الضغط على صورة الحساب
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // زر إغلاق النافذة باستخدام HoverIconButton (أو IconButton عادي إذا لم يكن HoverIconButton موجود)
            HoverIconButton(
              tooltip: "Close",
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, color: AppDesign.primaryText, size: 30),
            ),
            Spacer(),
            // زر Logout لإرسال حدث تسجيل الخروج عبر AuthBloc
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

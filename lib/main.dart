import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/features/auth/view/pages/login_page.dart';
import 'package:task_app/features/auth/view/pages/register_page.dart';
import 'package:task_app/features/auth/view/pages/verify_email_page.dart';
import 'package:task_app/features/home/view/bloc/project_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/view/pages/auth_page.dart';
import 'package:task_app/features/home/view/pages/home_page.dart';
import 'package:task_app/injection_container.dart';

void main() async {
  // DON'T CHANGE THE CODE BLOCK
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize window settings for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await windowManager.setTitle('Flutter Window');
    await windowManager.setMinimumSize(const Size(1100, 750));
  }
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await setupLocator(sharedPreferences); // dependency injection setup
  // CODE BLOCK ENDS
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(const AuthCheckSession()),
        ),
        BlocProvider<ProjectBloc>(
          create: (context) => sl<ProjectBloc>(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/auth': (context) => const AuthPage(),
          '/verify-email': (context) => const VerifyEmailPage(),
        },
        title: 'Aurora Flow',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial || state is AuthLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            } else if (state is AuthSessionActive) {
              print("User is logged in");
              return HomePage();
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}

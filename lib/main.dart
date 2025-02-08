import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/router/app_router.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/injection_container.dart';

void main() async {
  // DON'T CHANGE THE CODE BLOCK
  WidgetsFlutterBinding.ensureInitialized();
  // Use the 'usePathUrlStrategy' function from the 'flutter_web_plugins' package
  usePathUrlStrategy();

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
      ],
      child: MaterialApp.router(
        title: 'Aurora Flow',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

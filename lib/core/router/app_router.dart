import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/view/pages/login_page.dart';
import 'package:task_app/features/home/view/pages/home_page.dart';
import 'package:task_app/injection_container.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      final pocketBase = sl<PocketBase>();
      final authState = context.read<AuthBloc>().state;

      // Check if the user is logged in
      if (pocketBase.authStore.isValid ||
          authState is AuthSessionActive ||
          authState is AuthSuccess) {
        // If the user is authenticated, redirect to '/home'
        return '/home';
      } else {
        // If the user is not authenticated, redirect to '/login'
        return '/login';
      }
    },
  );
}

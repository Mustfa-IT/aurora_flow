import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Center(
        child: ElevatedButton(
          onPressed: () => logout(context),
          child: Text('Logout'),
        ),
      ),
    );
  }
}

void logout(BuildContext context) {
  context.read<AuthBloc>().add(AuthLogoutRequested());
}

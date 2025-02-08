import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController emailController =
      TextEditingController(text: "user@example.com");
  final TextEditingController passwordController =
      TextEditingController(text: "password123");
  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Register failed: ${state.error}")),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                "Register successful! Welcome ${state.user.email}",
              )),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          //
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    beginRegister(context);
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> beginRegister(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;
    context.read<AuthBloc>().add(
        AuthRegisterRequested(email: email, password: password, name: name));
  }
}

/// A stateless widget that represents the login page of the application.
///
/// This page contains text fields for the user to input their email and password,
/// and a login button to initiate the login process. It uses the `BlocConsumer`
/// widget to listen to the authentication state and display appropriate messages
/// or loading indicators.
///
/// The `emailController` and `passwordController` are used to manage the text
/// input for the email and password fields respectively.
///
/// The `BeginLogin` method is called when the login button is pressed. It reads
/// the email and password from the text controllers and dispatches an
/// `AuthLoginRequested` event to the `AuthBloc`.
///
/// The `listener` in the `BlocConsumer` displays a `SnackBar` with a message
/// depending on whether the login was successful or failed.
///
/// The `builder` in the `BlocConsumer` displays a loading indicator when the
/// authentication state is `AuthLoading`, and otherwise displays the login form.
library;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController =
      TextEditingController(text: "mustafafuzeit@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "Alaa1290@@");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Don't Change THE code below
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login failed: ${state.error}")),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text("Login successful! Welcome ${state.user.email}")),
            );
            Navigator.of(context).popAndPushNamed(
              '/home',
            );
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    BeginLogin(context);
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void BeginLogin(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;
    context
        .read<AuthBloc>()
        .add(AuthLoginRequested(email: email, password: password));
  }
  //تعديل تجريبي 
}

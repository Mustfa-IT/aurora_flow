import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/view/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController emailController =
      TextEditingController(text: "user@example.com");
  final TextEditingController passwordController =
      TextEditingController(text: "password123");

  // المتغير لتبديل إظهار/إخفاء كلمة المرور
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // حساب عرض الشاشة وتحديد عرض النموذج بثلث عرض الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth / 3;

    return Scaffold(
      body: Stack(
        children: [
          // الشعار في أعلى اليسار
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/logo-image.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          // حذف زر Log In في أعلى اليمين (تمت إزالته)
          // المحتوى الرئيسي: نموذج التسجيل في منتصف الشاشة
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(16.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Register failed: ${state.error}"),
                        ),
                      );
                    } else if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Register successful! Welcome ${state.user.email}"),
                        ),
                      );
                      Navigator.of(context).popAndPushNamed('/home');
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        // حقل الاسم الكامل
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // حقل البريد الإلكتروني
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // حقل كلمة المرور مع أيقونة العين لتبديل إظهار/إخفاء النص
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // زر Sign Up لتنفيذ عملية التسجيل
                        ElevatedButton(
                          onPressed: () => beginRegister(context),
                          child: const Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // زر "I already have an account" للتوجه إلى صفحة تسجيل الدخول
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            'I already have an account',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // زر العودة في أسفل الصفحة للرجوع إلى الصفحة السابقة
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> beginRegister(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;
    context.read<AuthBloc>().add(
          AuthRegisterRequested(email: email, password: password, name: name),
        );
  }
}



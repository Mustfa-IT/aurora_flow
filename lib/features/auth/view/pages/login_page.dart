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
import 'package:task_app/features/auth/view/pages/register_page.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // للتحكم في إظهار/إخفاء كلمة السر

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth / 3;

    return Scaffold(
      body: Stack(
        children: [
          // الجزء العلوي: الشعار على اليسار وزر Sign Up على اليمين
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/logo-image.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
          // المحتوى الرئيسي: نموذج تسجيل الدخول في منتصف الشاشة بعرض ثلث الشاشة
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Log In',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    // زر تسجيل الدخول عبر جوجل مع أيقونة   
                    ElevatedButton.icon(
                      // منطق تسجيل الدخول عبر جوجل (إن وجد)
                      onPressed: () {
                        AppUtils.showComingSoonMessage(context); // استدعاء الدالة
                      },
                      icon: const Icon(
                        Icons.g_mobiledata, // أيقونة بديلة تمثل جوجل
                        color: Colors.red,
                        size: 24,
                      ),
                      label: const Text('Log in with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // زر للخدمات الإضافية (إن وُجدت)
                    TextButton(
                       // منطق خدمات إضافية
                      onPressed: () {
                       AppUtils.showComingSoonMessage(context); // استدعاء الدالة
                      },
                      child: const Text(
                        'more services',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'or with your Aurora account',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // حقل البريد الإلكتروني أو اسم المستخدم
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email or Username',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // حقل كلمة المرور مع أيقونة العين
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword; // تغيير الحالة
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      obscureText: _obscurePassword, // تطبيق حالة إخفاء النص
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Login failed: ${state.error}')),
                          );
                        } else if (state is AuthSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Login successful! Welcome ${state.user.email}')),
                          );
                          Navigator.of(context).popAndPushNamed('/home');
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return Column(
                          children: [
                            // زر تسجيل الدخول الرئيسي
                            ElevatedButton(
                              onPressed: () => _beginLogin(context),
                              child: const Text('Log In'),
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
                            // زر "I forgot my password"
                            TextButton(
                              // منطق استعادة كلمة المرور إن وُجد
                              onPressed: () {
                                AppUtils.showComingSoonMessage(
                                    context); // استدعاء الدالة
                              },
                              child: const Text(
                                'I forgot my password',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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

  void _beginLogin(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;
    context
        .read<AuthBloc>()
        .add(AuthLoginRequested(email: email, password: password));
  }
}

//كلاس يستخدم عند الحاجة لعرض رسالة 
class AppUtils {
  /// دالة لعرض رسالة تنبيه
  static void showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "This option will be available soon. We are currently in the development phase.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

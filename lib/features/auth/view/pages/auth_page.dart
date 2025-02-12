import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/auth/view/bloc/auth_bloc.dart';
import 'package:task_app/features/auth/view/pages/login_page.dart';
import 'package:task_app/features/auth/view/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isNavigated = false;

  @override
  void initState() {
    context.read<AuthBloc>().add(const AuthCheckSession());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isNavigated &&
        (context.read<AuthBloc>().state is AuthSuccess ||
            context.read<AuthBloc>().state is AuthSessionActive)) {
      _isNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed('/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // حساب حجم الشاشة وحجم الشعار كنسبة من عرض وارتفاع الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = screenWidth * 0.15; // على سبيل المثال 15% من عرض الشاشة

    final screenHeight = MediaQuery.of(context).size.height;
    final logoHeight = screenHeight * 0.30; // على سبيل المثال 30% من ارتفاع الشاشة

    return Scaffold(
      body: Stack(
        children: [
          // المحتوى الرئيسي
          Row(
            children: [
              Expanded(
                flex: 6, // الجزء الخاص بالنصوص والأزرار
                child: Padding(
                  // إضافة حشوة من الجهة اليسرى بحيث يكون هناك مسافة بين الشعار والمحتوى
                  padding: EdgeInsets.only(
                    left: logoWidth + 20.0, // شعار + مسافة إضافية (20 بكسل)
                    right: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Aurora Flow",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Secure Task Management for You Alone or with Your Team",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Your Team. United for Success.",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Log In",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            child: const Text(
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4, // الجزء الخاص بالصورة أو التصميم
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login-image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // إضافة الشعار في الزاوية العلوية اليسرى بشكل متجاوب
          Positioned(
            top: 10,
            left: 10,
            child: Image.asset(
              'assets/logo.png',
              width: logoWidth,
              height: logoHeight,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

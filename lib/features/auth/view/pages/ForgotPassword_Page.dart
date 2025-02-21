import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: AuthFormContainer(
            title: 'Forgot Password',
            subtitle: 'Enter your email address to reset your password.',
            children: [
              // حقل إدخال البريد الإلكتروني
              CustomTextField(
                controller: emailController,
                labelText: 'Email Address',
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 30),
              // زر إرسال رابط إعادة تعيين كلمة المرور
              CustomButton(
                text: 'Send Reset Email',
                onPressed: () => _navigateToVerificationPage(context),
              ),
              const SizedBox(height: 20),
              // زر الرجوع إلى تسجيل الدخول
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToVerificationPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => VerificationCodePage()),
    );
  }
}

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: AuthFormContainer(
            title: 'Enter Verification Code',
            subtitle: 'Check your email for the verification code.',
            children: [
              // حقل إدخال رمز التحقق
              CustomTextField(
                controller: codeController,
                labelText: 'Verification Code',
                prefixIcon: Icons.verified,
              ),
              const SizedBox(height: 30),
              // زر التحقق من الرمز
              CustomButton(
                text: 'Verify',
                onPressed: () => _navigateToResetPasswordPage(context),
              ),
              const SizedBox(height: 20),
              // زر الرجوع إلى تسجيل الدخول
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToResetPasswordPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: AuthFormContainer(
            title: 'Reset Password',
            subtitle: 'Enter your new password below.',
            children: [
              // حقل إدخال كلمة المرور الجديدة
              CustomTextField(
                controller: passwordController,
                labelText: 'New Password',
                prefixIcon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              // حقل تأكيد كلمة المرور
              CustomTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              // زر إعادة تعيين كلمة المرور
              CustomButton(
                text: 'Reset Password',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              // زر الرجوع إلى تسجيل الدخول
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// مكون حاوية نمطية لصفحات المصادقة (إعادة الاستخدام لتوحيد التصميم)
class AuthFormContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AuthFormContainer({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth / 3;

    return Container(
      width: formWidth,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شعار التطبيق
          Image.asset(
            'assets/logo-image.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

// مكون حقل إدخال مخصص يدعم عرض/إخفاء كلمة المرور
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool isPassword;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? isObscured : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off :Icons.visibility ,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 5,
      ),
      child: Text(text),
    );
  }
}

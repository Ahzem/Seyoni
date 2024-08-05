import 'package:flutter/material.dart';
import 'src/pages/auth/forgot-password/new_password.page.dart';
import 'src/pages/auth/forgot-password/verify_code_page.dart';
import 'src/pages/main/mainpage.dart';
import 'src/pages/sign-pages/signup_page.dart';
import 'src/pages/entry-pages/instruction_page.dart';
import './src/pages/entry-pages/launch_screen.dart';
import './src/pages/sign-pages/signin_page.dart';
import './src/config/route.dart';
import 'src/pages/auth/otp/otp_screen.dart';
import 'src/pages/auth/forgot-password/forgot_password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LaunchScreen(),
        AppRoutes.instruction: (context) => const InstructionPage(),
        AppRoutes.signIn: (context) => SignInPage(),
        AppRoutes.signUp: (context) => SignUpPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.otppage: (context) => const OtpScreen(),
        AppRoutes.otppagefornewpassword: (context) =>
            const OtpScreenForNewPassword(),
        AppRoutes.forgotpassword: (context) => ForgotPasswordPage(),
        AppRoutes.resetPassword: (context) => const ResetPasswordPage()
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../pages/auth/forgot-password/verify_code_page.dart';
import '../pages/sign-pages/signup_page.dart';
import '../pages/auth/otp/otp_screen.dart';
import '../pages/sign-pages/signin_page.dart';
import '../pages/main/mainpage.dart';
import '../pages/entry-pages/launch_screen.dart';
import '../pages/entry-pages/instruction_page.dart';
import '../pages/auth/forgot-password/forgot_password_page.dart';
import '../pages/auth/forgot-password/new_password.page.dart';

class AppRoutes {
  static const String launch = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String instruction = '/instruction';
  static const String otppage = '/otp';
  static const String alertSuccess = '/alertSuccess';
  static const String forgotpassword = '/forgot-password';
  static const String otppagefornewpassword = '/otp-for-new-password';
  static const String resetPassword = '/reset-password';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.launch:
      return MaterialPageRoute(builder: (_) => const LaunchScreen());
    case AppRoutes.signIn:
      return MaterialPageRoute(builder: (_) => SignInPage());
    case AppRoutes.signUp:
      return MaterialPageRoute(builder: (_) => SignUpPage());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.instruction:
      return MaterialPageRoute(builder: (_) => const InstructionApp());
    case AppRoutes.otppage:
      return MaterialPageRoute(builder: (_) => const OtpScreen());
    case AppRoutes.otppagefornewpassword:
      return MaterialPageRoute(builder: (_) => const OtpScreenForNewPassword());
    case AppRoutes.forgotpassword:
      return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
    case AppRoutes.resetPassword:
      return MaterialPageRoute(builder: (_) => const ResetPasswordPage());

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

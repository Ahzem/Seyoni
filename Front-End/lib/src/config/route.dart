import 'package:flutter/material.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/provider/provider_entry_page.dart';
import '../pages/seeker/forgot-password/verify_code_page.dart';
import '../pages/provider/home/provider_home_page.dart';
import '../pages/provider/login/provider_signin_page.dart';
import '../pages/provider/registration/provider_registration_page.dart';
import '../pages/seeker/order-history/order_history_page.dart';
import '../pages/seeker/sign-pages/signup_page.dart';
import '../pages/seeker/sign-pages/otp/otp_screen.dart';
import '../pages/seeker/sign-pages/signin_page.dart';
import '../pages/seeker/main/mainpage.dart';
import '../pages/entry-pages/launch_screen.dart';
import '../pages/entry-pages/instruction_page.dart';
import '../pages/seeker/forgot-password/forgot_password_page.dart';
import '../pages/seeker/forgot-password/new_password.page.dart';
import '../pages/seeker/notifications/internal/notification_page.dart';
import '../widgets/alertbox/menu.dart';

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
  static const String notification = '/notification';
  static const String alertMenu = '/alertMenu';
  static const String providerSignUp = '/provider-signup';
  static const String providerSignIn = '/provider-signin';
  static const String providerHomePage = '/provider-home';
  static const String orderHistoryPage = '/order-history';
  static const String providerEntryPage = '/provider-entry';
  static const String adminHomePage = '/admin-home';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.launch:
      return MaterialPageRoute(
          builder: (_) => LaunchScreen(
                onLaunchScreenComplete: (context) {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.instruction);
                },
              ));
    case AppRoutes.signIn:
      return MaterialPageRoute(builder: (_) => const SignInPage());
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
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
    case AppRoutes.resetPassword:
      return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
    case AppRoutes.notification:
      return MaterialPageRoute(builder: (_) => const NotificationPage());
    case AppRoutes.alertMenu:
      return MaterialPageRoute(builder: (_) => const MenuSignOut());
    case AppRoutes.providerSignUp:
      return MaterialPageRoute(
          builder: (_) => const ProviderRegistrationPage());
    case AppRoutes.providerSignIn:
      return MaterialPageRoute(builder: (_) => const ProviderSignInPage());
    case AppRoutes.providerHomePage:
      return MaterialPageRoute(builder: (_) => const ProviderHomePage());
    case AppRoutes.orderHistoryPage:
      return MaterialPageRoute(builder: (_) => const OrderHistoryPage());
    case AppRoutes.providerEntryPage:
      return MaterialPageRoute(builder: (_) => const ProviderEntryPage());
    case AppRoutes.adminHomePage:
      return MaterialPageRoute(builder: (_) => const AdminHomePage());
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

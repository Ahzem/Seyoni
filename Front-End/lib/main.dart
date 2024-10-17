import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/pages/admin/admin_home_page.dart';
import 'src/pages/admin/list_of_providers.dart';
import 'src/pages/admin/list_of_reg_requests.dart';
import 'src/pages/admin/list_of_seekers.dart';
import 'src/pages/provider/provider_entry_page.dart';
import 'src/pages/seeker/forgot-password/new_password.page.dart';
import 'src/pages/seeker/forgot-password/verify_code_page.dart';
import 'src/pages/seeker/main/mainpage.dart';
import 'src/pages/provider/home/provider_home_page.dart';
import 'src/pages/provider/login/provider_signin_page.dart';
import 'src/pages/provider/registration/provider_registration_page.dart';
import 'src/pages/seeker/order-history/order_history_page.dart';
import 'src/pages/seeker/sign-pages/signup_page.dart';
import 'src/pages/entry-pages/instruction_page.dart';
import './src/pages/entry-pages/launch_screen.dart';
import 'src/pages/seeker/sign-pages/signin_page.dart';
import './src/config/route.dart';
import 'src/pages/seeker/sign-pages/otp/otp_screen.dart';
import 'src/pages/seeker/forgot-password/forgot_password_page.dart';
import 'src/pages/seeker/notifications/internal/notification_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await _requestPermissions();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  bool hasSeenLaunchScreen = prefs.getBool('hasSeenLaunchScreen') ?? false;
  runApp(MyApp(token: token, hasSeenLaunchScreen: hasSeenLaunchScreen));
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.photos,
    Permission.location,
  ].request();
}

class MyApp extends StatelessWidget {
  final String? token;
  final bool hasSeenLaunchScreen;

  const MyApp({super.key, this.token, required this.hasSeenLaunchScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => _getInitialPage(),
        AppRoutes.instruction: (context) => const InstructionPage(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.signUp: (context) => SignUpPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.otppage: (context) => const OtpScreen(),
        AppRoutes.otppagefornewpassword: (context) =>
            const OtpScreenForNewPassword(),
        AppRoutes.forgotpassword: (context) => const ForgotPasswordPage(),
        AppRoutes.resetPassword: (context) => const ResetPasswordPage(),
        AppRoutes.notification: (context) => const NotificationPage(),
        AppRoutes.providerSignIn: (context) => const ProviderSignInPage(),
        AppRoutes.providerSignUp: (context) => const ProviderRegistrationPage(),
        AppRoutes.providerHomePage: (context) => const ProviderHomePage(),
        AppRoutes.orderHistoryPage: (context) => const OrderHistoryPage(),
        AppRoutes.providerEntryPage: (context) => const ProviderEntryPage(),
        AppRoutes.adminHomePage: (context) => const AdminHomePage(),
        AppRoutes.listOfRegistrationRequests: (context) =>
            const ListOfRegistrationRequests(),
        AppRoutes.listOfSeekers: (context) => const ListOfSeekers(),
        AppRoutes.listOfProviders: (context) => const ListOfProviders(),
      },
    );
  }

  Widget _getInitialPage() {
    if (!hasSeenLaunchScreen) {
      return LaunchScreen(onLaunchScreenComplete: _onLaunchScreenComplete);
    } else if (token != null && !JwtDecoder.isExpired(token!)) {
      return const HomePage();
    } else {
      return const SignInPage();
    }
  }

  void _onLaunchScreenComplete(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenLaunchScreen', true);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
  }
}

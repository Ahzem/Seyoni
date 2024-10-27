import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
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
import 'src/widgets/draggable_button.dart'; // Import the DraggableFloatingActionButton

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppInitializer());
}

class AppInitializer extends StatefulWidget {
  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<Map<String, dynamic>> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<Map<String, dynamic>> _initializeApp() async {
    await dotenv.load(fileName: ".env");
    await _requestPermissions();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userType = prefs.getString('userType');
    bool hasSeenLaunchScreen = prefs.getBool('hasSeenLaunchScreen') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return {
      'token': token,
      'userType': userType,
      'hasSeenLaunchScreen': hasSeenLaunchScreen,
      'isLoggedIn': isLoggedIn,
    };
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.location,
    ];

    if (!kIsWeb) {
      permissions.add(Permission.photos);
      permissions.add(Permission.storage);
    }

    await permissions.request();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        } else {
          final data = snapshot.data!;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => NotificationProvider()),
              // Add other providers here if needed
            ],
            child: MyApp(
              token: data['token'],
              userType: data['userType'],
              hasSeenLaunchScreen: data['hasSeenLaunchScreen'],
              isLoggedIn: data['isLoggedIn'],
            ),
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? userType;
  final bool hasSeenLaunchScreen;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    this.token,
    this.userType,
    required this.hasSeenLaunchScreen,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      navigatorKey: navigatorKey,
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
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (isLoggedIn && userType == 'seeker')
              DraggableFloatingActionButton(navigatorKey: navigatorKey),
          ],
        );
      },
    );
  }

  Widget _getInitialPage() {
    if (!hasSeenLaunchScreen) {
      return LaunchScreen(onLaunchScreenComplete: _onLaunchScreenComplete);
    } else if (isLoggedIn && token != null && !JwtDecoder.isExpired(token!)) {
      if (userType == 'provider') {
        return const ProviderHomePage();
      } else {
        return const HomePage();
      }
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

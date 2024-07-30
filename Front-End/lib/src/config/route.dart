import 'package:flutter/material.dart';
import 'package:seyoni/src/pages/sign-pages/signup_page.dart';
import '../pages/sign-pages/signin_page.dart';
import '../pages/home-page/homepage.dart';
import '../pages/entry-pages/launch_screen.dart';
import '../pages/entry-pages/instruction_page.dart';

class AppRoutes {
  static const String launch = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String instruction = '/instruction';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.launch:
      return MaterialPageRoute(builder: (_) => const LaunchScreen());
    case AppRoutes.signIn:
      return MaterialPageRoute(builder: (_) => const SignInPage());
    case AppRoutes.signUp:
      return MaterialPageRoute(builder: (_) => const SignUpPage());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case AppRoutes.instruction:
      return MaterialPageRoute(builder: (_) => const InstructionApp());
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

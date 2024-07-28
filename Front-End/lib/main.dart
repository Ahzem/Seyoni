import 'package:flutter/material.dart';
import './src/pages/home-page/homepage.dart';
import 'package:seyoni/src/pages/sign-pages/signup_page.dart';
import 'src/pages/entry-pages/instruction_page.dart';
import './src/pages/entry-pages/launch_screen.dart';
import './src/pages/sign-pages/signin_page.dart';
import './src/config/route.dart';

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
        AppRoutes.instruction1: (context) => const InstructionPage(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
    );
  }
}

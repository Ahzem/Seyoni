import 'package:flutter/material.dart';
import 'package:seyoni/src/pages/sign-pages/signup_page.dart';
import './src/pages/entry-pages/instruction_page_1.dart';
import './src/pages/entry-pages/instruction_page_2.dart';
import './src/pages/entry-pages/instruction_page_3.dart';
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
        AppRoutes.instruction1: (context) => const InstructionPage1(),
        AppRoutes.instruction2: (context) => const InstructionPage2(),
        AppRoutes.instruction3: (context) => const InstructionPage3(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
      },
    );
  }
}

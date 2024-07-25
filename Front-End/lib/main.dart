import 'package:flutter/material.dart';
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
      initialRoute: AppRoutes.launch,
      onGenerateRoute: generateRoute,
      routes: {
        AppRoutes.launch: (context) => LaunchScreen(),
        AppRoutes.instruction1: (context) => instructionPage1(),
        AppRoutes.instruction2: (context) => instructionPage2(),
        AppRoutes.instruction3: (context) => instructionPage3(),
        AppRoutes.signIn: (context) => SignInPage(),
      },
    );
  }
}

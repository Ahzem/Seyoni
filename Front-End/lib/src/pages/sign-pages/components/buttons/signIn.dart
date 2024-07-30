import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Sign in button
class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.28,
          vertical: height * 0.015,
        ),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// SignIn flattenbutton
class FlatenSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FlatenSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Sign In',
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

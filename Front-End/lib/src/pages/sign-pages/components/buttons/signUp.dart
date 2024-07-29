import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Sign up button
class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignUpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.3,
          vertical: height * 0.02,
        ),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// SignUp flattenbutton
class FlatenSignUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FlatenSignUpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Sign Up',
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

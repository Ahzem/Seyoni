import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Forgot password button
class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

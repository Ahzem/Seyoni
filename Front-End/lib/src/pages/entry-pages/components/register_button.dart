import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';

// Register Flatten button
class RegisterFlatButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterFlatButton({super.key, required this.onPressed});

  @override
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Register Now',
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

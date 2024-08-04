import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Resend button Active
class ResendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kTransparentColor,
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 90,
          vertical: 10,
        ),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text(
        'Resend',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

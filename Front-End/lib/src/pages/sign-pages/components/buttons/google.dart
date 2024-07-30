import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Sign in with Google button
class SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/google.png',
            height: 30,
          ),
          const SizedBox(width: 5),
          const Text(
            'Google',
            style: TextStyle(color: kParagraphTextColor),
          ),
        ],
      ),
    );
  }
}

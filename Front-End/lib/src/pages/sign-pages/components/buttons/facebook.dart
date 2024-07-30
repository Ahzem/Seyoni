import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Sign in with Facebook button
class SignInWithFacebookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithFacebookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/facebook.png',
            height: 30,
          ),
          const SizedBox(width: 10),
          const Text(
            'Facebook',
            style: TextStyle(color: kParagraphTextColor),
          ),
        ],
      ),
    );
  }
}
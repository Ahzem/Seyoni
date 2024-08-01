import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';

// Verify button Active
class VerifyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VerifyButton({super.key, required this.onPressed});

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
        'Verify',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// Verify button Inactive
class VerifyButtonInactive extends StatelessWidget {
  final VoidCallback onPressed;

  const VerifyButtonInactive({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor.withOpacity(0.5),
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
        'Verify',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

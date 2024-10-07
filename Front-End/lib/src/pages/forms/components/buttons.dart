import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryOutlinedButton(text: "Cancel", onPressed: () {}),
        const SizedBox(width: 16),
        PrimaryFilledButton(text: "Reserve", onPressed: () {}),
      ],
    );
  }
}

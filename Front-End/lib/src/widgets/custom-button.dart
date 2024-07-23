import 'package:flutter/material.dart';
import '../constants/constants-color.dart';

/* Custom button widget 
  * 
  * This widget is used to create a custom button with a primary color background
  * and white text. The button text is passed as a parameter to the widget.
  * 
  * Parameters:
  * - onPressed: VoidCallback - The function to be called when the button is pressed
  * - text: String - The text to be displayed on the button
  * 
  * Example:
  * 
  * CustomButton(
  *   onPressed: () {
  *     // Add your button action here
  *   },
  *   text: 'Button Text',
  * )
  *                   CustomButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InstructionPage2(),
                            ),
                          );
                        },
                        text: 'Next',
                      ),
  */

// Filled button with primary color background and white text
class CustomButtonFilled extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButtonFilled({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: kBackgroundColor,
        backgroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(text),
    );
  }
}

// Outlined button with primary color border and white text
class CustomButtonOutlined extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButtonOutlined({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        backgroundColor: kTransparentColor,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        side: const BorderSide(
          color: kPrimaryColor,
          width: 2,
        ),
      ),
      child: Text(text),
    );
  }
}

// Custom button with white background and primary color text
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
        backgroundColor: kBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(text),
    );
  }
}

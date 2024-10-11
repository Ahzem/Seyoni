import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? Function(String?) validate;
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.validate,
      required String? Function(dynamic value) validator,
      required bool obscureText,
      required TextInputType keyboardType,
      required TextEditingController controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      validator: validate,
    );
  }
}

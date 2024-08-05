import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../constants.dart';
import '../decor/newPw.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PasswordField({
    required Key key,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: kTextFieldStyle,
      decoration: kNewPasswordFieldDecoration.copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: kParagraphTextColor,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      cursorColor: kPrimaryColor,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
    );
  }
}

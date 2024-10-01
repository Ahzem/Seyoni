import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../constants.dart';
import '../decor/new_pw.dart';

class NewPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const NewPasswordField({
    required Key key,
    required this.controller,
  }) : super(key: key);

  @override
  NewPasswordFieldState createState() => NewPasswordFieldState();
}

class NewPasswordFieldState extends State<NewPasswordField> {
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
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is required';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        } else if (value.contains(' ')) {
          return 'Password must not contain any spaces';
        } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
            .hasMatch(value)) {
          return 'Password must contain at least one uppercase letter, one lowercase letter and one number';
        }
        return null;
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

// Sign in form:

class RememberMeCheckbox extends StatefulWidget {
  const RememberMeCheckbox({super.key});

  @override
  _RememberMeCheckboxState createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kContainerColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
            side: const BorderSide(color: kPrimaryColor),
            checkColor: Colors.white, // Color of the check mark
            activeColor: kPrimaryColor, // Color when the checkbox is checked
          ),
        ),
        const SizedBox(width: 2.0),
        const Text('Remember Me',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

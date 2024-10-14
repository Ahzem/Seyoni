import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: TextField(
              cursorColor: kPrimaryColor,
              controller: controller,
              decoration: InputDecoration(
                icon: Icon(Icons.message, color: kPrimaryColor),
                hintText: "Enter your message",
                hintStyle: kBodyTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
              style: kInputTextStyle,
              maxLines: 5,
            ),
          ),
        ),
      ),
    );
  }
}

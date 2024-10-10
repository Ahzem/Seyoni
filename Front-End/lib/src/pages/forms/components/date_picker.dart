import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

class DatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onPickDate;

  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.date_range, size: 24, color: kPrimaryColor),
                SizedBox(width: 5),
                TextButton(
                  onPressed: onPickDate,
                  child: Text(
                    selectedDate != null
                        ? selectedDate.toString().split(' ')[0]
                        : "Pick a date",
                    style: kBodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

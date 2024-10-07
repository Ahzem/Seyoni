import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

class TimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onPickTime;

  const TimePicker({
    super.key,
    required this.selectedTime,
    required this.onPickTime,
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
                Icon(Icons.access_time, size: 24, color: kPrimaryColor),
                SizedBox(width: 5),
                TextButton(
                  onPressed: onPickTime,
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : "Pick a time",
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

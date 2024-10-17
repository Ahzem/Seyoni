import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

class RecordField extends StatelessWidget {
  final VoidCallback onRecord;

  const RecordField({
    super.key,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: Column(
              children: [
                const Icon(Icons.mic, size: 24, color: kPrimaryColor),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: onRecord,
                  child: const Text(
                    "Record",
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

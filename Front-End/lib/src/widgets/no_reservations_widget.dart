import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/custom_button.dart';

class NoReservationsWidget extends StatelessWidget {
  final String message;

  const NoReservationsWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: kSubtitleTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryOutlinedButton(
            text: 'Go Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

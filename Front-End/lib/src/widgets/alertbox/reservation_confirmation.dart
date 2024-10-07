import 'package:flutter/material.dart';
import '../../constants/constants_color.dart';
import '../../constants/constants_font.dart';
import '../custom_button.dart';
import 'dart:ui';

class ReservationConfirmation extends StatelessWidget {
  final VoidCallback onContinueEditing;
  final VoidCallback onConfirm;

  const ReservationConfirmation({
    super.key,
    required this.onContinueEditing,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Opacity(
          opacity: 0.5, // Background opacity
          child: ModalBarrier(
            dismissible: true,
            color: Colors.black,
          ),
        ),
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Reservation Confirmation',
                      style: kAlertTitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      color: kPrimaryColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    const Text(
                      'Are you sure you want to confirm this reservation? Please review all details carefully.',
                      style: kAlertDescriptionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryOutlinedButtonTwo(
                          text: 'Continue Editing',
                          onPressed: onContinueEditing,
                        ),
                        const SizedBox(width: 10),
                        PrimaryFilledButtonThree(
                          text: 'Confirm',
                          onPressed: onConfirm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

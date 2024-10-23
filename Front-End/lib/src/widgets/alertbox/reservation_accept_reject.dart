import 'package:flutter/material.dart';
import '../../constants/constants_color.dart';
import '../../constants/constants_font.dart';
import '../custom_button.dart';
import 'dart:ui';

class ReservationAcceptReject extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String action;

  const ReservationAcceptReject({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.action,
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
                    Text(
                      'Reservation $action',
                      style: kAlertTitleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      color: kPrimaryColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    Text(
                      'Are you sure you want to $action this reservation?',
                      style: kAlertDescriptionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryOutlinedButtonTwo(
                          text: 'Cancel',
                          onPressed: onCancel,
                        ),
                        const SizedBox(width: 20),
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

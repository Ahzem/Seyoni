import 'package:flutter/material.dart';
import 'package:seyoni/src/widgets/alertbox/reservation_confirmation.dart';
import '../../../widgets/alertbox/unsaved_changes.dart';
import '../../../widgets/custom_button.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryOutlinedButton(
          text: "Cancel",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return UnsavedChanges(
                  onContinueEditing: () {
                    // Staying on the page and continue editing
                    Navigator.of(context).pop();
                  },
                  onLeave: () {
                    // Back to the previous page
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Go back to the previous page
                  },
                );
              },
            );
          },
        ),
        const SizedBox(width: 16),
        PrimaryFilledButton(
          text: "Reserve",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ReservationConfirmation(
                  onConfirm: () {
                    // Add your confirmation logic here
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reservation confirmed!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onContinueEditing: () {
                    // Staying on the page and continue editing
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

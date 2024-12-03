import 'package:flutter/material.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import '../../../../../constants/constants_color.dart';
import '../../../../../constants/constants_font.dart';
import '../../../../../widgets/custom_button.dart';
import 'add_new_card.dart';

class AddPaymentMethodPage extends StatelessWidget {
  const AddPaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white, 
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'My Cards',
            style: kTitleTextStyle,
          ),
          backgroundColor: kTransparentColor, 
          centerTitle: true, 
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PrimaryFilledButtonTwo(
                text: 'Add new card',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddNewCardBottomSheet(),
                  );
                },

              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.shield, // Shield icon
                        size: 24.0, // Adjust size as needed
                      ),
                      Icon(
                        Icons.verified, // Verified checkmark icon
                        size: 16.0, 
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(width: 8), // Space between icon and text
                  Text(
                    'Your information is safe with us.',
                    style: kSubtitleTextStyle2,
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}


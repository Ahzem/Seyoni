import 'package:flutter/material.dart ';

import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../widgets/custom_button.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
                color: Colors.white
                ), // iOS-style back arrow icon
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kTransparentColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Reduce vertical padding,
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align content to the top
              children: [
                // Card with content
                Expanded(
                  // Allow the card to take up available vertical space
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
                    elevation: 2, // Shadow effect
                    color: kTransparentColor, // Background color for the card
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        shrinkWrap: true, // Allow the ListView to fit the Card
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png', // Path to the logo image
                              height: 45,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Delete Your Account',
                            style: kTitleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                             'When you use SEYONI, we store your data to facilitate seamless interactions between SERVICE SEEKERS and PROVIDERS and to offer related services. If you choose to delete your personal account, all your data generated on SEYONI will be permanently deleted, and we will no longer be able to provide our services to you.',
                              style: kBodyTextStyle,
                          ),
                          SizedBox(height: 16.0),
                          Icon(
                              Icons.warning,
                              color: kPrimaryColor, size: 40),
                          SizedBox(height: 16.0),
                          Text(
                              'Please note that requesting to delete your account is final and irreversible. Consider this decision carefully before proceeding.',
                              style: kBodyTextStyle
                              ),
                          SizedBox(height: 16.0),
                          Text(
                              'This action may affect other pending actions or requests associated with your account.',
                              style: kBodyTextStyle
                              ),
                          SizedBox(height: 16.0),
                          Text(
                              'Before processing your account deletion, we will assess the current status of your account. This review includes evaluating whether removing your data might impact your rights, ongoing service reservations, feedback, or any legal obligations that need to be met.',
                              style: kBodyTextStyle
                              ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, 
                            children: [
                              PrimaryFilledButton(
                                text: 'Delete Account',
                                onPressed: () {
                                  Navigator.pop(context); 
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
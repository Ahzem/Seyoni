import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/background_widget.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.white), // iOS-style back arrow icon
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
                          SizedBox(height: 10),
                          Text(
                            'About Seyoni',
                            style: kTitleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Welcome to Seyoni, your trusted platform for connecting you with reliable service providers. From plumbing and house cleaning to babysitting, elder care, and more, we make it easy to find professionals for your needs.',
                            style: kBodyTextStyle,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                              'At Seyoni, we connect you with skilled, dependable service providers for a seamless, convenient experience. Our focus is on professionalism and quality, ensuring you get the right help when you need it most.',
                              style: kBodyTextStyle),
                          SizedBox(height: 16.0),
                          Text(
                              'We prioritize trust and safety by thoroughly vetting all service providers. Our platform offers a variety of services, allowing you to choose the best fit based on ratings, reviews, and detailed profiles.',
                              style: kBodyTextStyle),
                          SizedBox(height: 16.0),
                          Text(
                              'Whether you need help with repairs, cleaning, or caregiving, Seyoni connects you with trusted service providers. We make it easy to find reliable help and ensure quality service for you and your family.',
                              style: kBodyTextStyle),
                          SizedBox(height: 16.0),
                          Text(
                              'Thank you for choosing SEYONI!. We look forward to serving you and providing the best service experience possible.',
                              style: kBodyTextStyle),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end, // Align items to the start (left)
                            children: [
                              Text(
                                'Team SEYONI',
                                style: kBodyTextStyle2,
                              ),
                              SizedBox(
                                  width:
                                      4.0), // Add space between the text and the logo
                              Image.asset(
                                'assets/images/logo-icon.png', // Path to the logo image
                                height: 10,
                                width: 10,
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

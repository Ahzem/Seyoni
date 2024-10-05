import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/custom_button.dart';
import 'components/profile_avatar.dart';
import 'components/icon_button_widget.dart';

class SeekerView extends StatefulWidget {
  const SeekerView({super.key});

  @override
  State<SeekerView> createState() => _SeekerViewState();
}

class _SeekerViewState extends State<SeekerView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "Profile",
                style: kSubtitleTextStyle,
              ),
            ),
          ],
        ),
        // Top profile section
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(150, 255, 255, 255),
                    width: 1,
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  ProfileAvatar(
                    imagePath: 'assets/images/profile-1.jpg', // Profile image
                    isOnline: true, // Online status
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mark Antony",
                    style: kTitleTextStyleBold,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Service Type - Plumber",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: kPrimaryColor),
                      Icon(Icons.star, color: kPrimaryColor),
                      Icon(Icons.star, color: kPrimaryColor),
                      Icon(Icons.star, color: kPrimaryColor),
                      Icon(Icons.star_border, color: kPrimaryColor),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4.0",
                        style: TextStyle(color: kParagraphTextColor),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "(85 Reviews)",
                        style: TextStyle(color: kParagraphTextColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  PrimaryFilledButtonTwo(text: "Hire", onPressed: () {}),
                  SizedBox(height: 10),
                  // Icons section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        icon: Icons.phone,
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      CustomIconButton(
                        icon: Icons.chat,
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      CustomIconButton(
                        icon: Icons.bookmark_added_sharp,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Badges Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BadgeWidget(icon: Icons.favorite, label: "Love"),
              BadgeWidget(icon: Icons.thumb_up, label: "Thumbs Up"),
              BadgeWidget(icon: Icons.check_circle, label: "Verified"),
            ],
          ),
        ),

        // Stats Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatWidget(label: 'Completed Works', value: '244+'),
            StatWidget(label: 'Customer Reviews', value: '85+'),
          ],
        ),

        // Gallery Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(3, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/logo-icon.png'), // Replace with gallery images
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const BadgeWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: kPrimaryColor),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class StatWidget extends StatelessWidget {
  final String label;
  final String value;

  const StatWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/custom_button.dart';

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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/profile-1.jpg'), // Profile image
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
                  Container(
                    decoration: BoxDecoration(
                      color: kTransparentColor,
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.phone, color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: kTransparentColor,
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chat, color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: kTransparentColor,
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.info_outline, color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ],
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

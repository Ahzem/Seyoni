import 'dart:ui';
import 'package:flutter/material.dart';
import 'components/badge_widget.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/custom_button.dart';
import 'components/full_screen_image.dart';
import 'components/profile_avatar.dart';
import 'components/icon_button_widget.dart';
import 'components/stat_widget.dart';
import './components/image_paths.dart'; // Import the image paths

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
                      SizedBox(width: 20),
                      CustomIconButton(
                        icon: Icons.chat,
                        onPressed: () {},
                      ),
                      SizedBox(width: 20),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(150, 255, 255, 255),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BadgeWidget(icon: Icons.star, label: "Hero"),
                  BadgeWidget(icon: Icons.flash_on, label: "Superman"),
                  BadgeWidget(icon: Icons.speed, label: "Quicker"),
                  BadgeWidget(icon: Icons.verified, label: "Trustabler"),
                ],
              ),
            ),
          ),
        ),

        // Stats Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatWidget(label: 'Completed Works', value: '240+'),
            StatWidget(label: 'Customer Reviews', value: '85+'),
          ],
        ),

        // Gallery Section
        Container(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gallery',
                  style: kTitleTextStyle,
                ),
                SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(imagePaths.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imagePath: imagePaths[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                imagePaths[index]), // Use image from the list
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

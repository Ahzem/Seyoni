import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../widgets/background_widget.dart';
import '../forms/hiring_form.dart';
import 'components/badge_widget.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/custom_button.dart';
import 'components/full_screen_image.dart';
import 'components/profile_avatar.dart';
import 'components/icon_button_widget.dart';
import 'components/stat_widget.dart';
import 'components/image_paths.dart'; // Import the image paths

class SeekerView extends StatefulWidget {
  final Map<String, dynamic> providerDetails;

  const SeekerView({super.key, required this.providerDetails});

  @override
  State<SeekerView> createState() => _SeekerViewState();
}

class _SeekerViewState extends State<SeekerView> {
  late String name;
  late String profileImage;
  late double rating;
  late String profession;
  late int completedWorks;

  @override
  void initState() {
    super.initState();
    name =
        '${widget.providerDetails['firstName']} ${widget.providerDetails['lastName']}';
    profileImage = widget.providerDetails['profileImageUrl'] ?? '';
    rating = (widget.providerDetails['rating'] ?? 5).toDouble();
    profession = widget.providerDetails['profession'];
    completedWorks = widget.providerDetails['completedWorks'] ?? 100;
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      try {
        return NetworkImage(imageUrl);
      } catch (e) {
        print('Error loading image: $e');
        return AssetImage('assets/images/profile-3.jpg'); // Fallback image
      }
    } else {
      return AssetImage('assets/images/profile-3.jpg'); // Fallback image
    }
  }

  void _navigateToHiringForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HiringForm(
          name: name,
          profileImage: profileImage,
          rating: rating,
          profession: profession,
          serviceType:
              widget.providerDetails['category'] ?? '', // Pass serviceType
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Profile', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top profile section
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
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
                                imagePath: profileImage, // Profile image
                                isOnline: true, // Online status
                                imageProvider: _getImageProvider(profileImage),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                name,
                                style: kTitleTextStyleBold,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Category - $profession",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
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
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                        color: kParagraphTextColor),
                                  ),
                                  const SizedBox(width: 15),
                                  const Text(
                                    "(85 Reviews)",
                                    style:
                                        TextStyle(color: kParagraphTextColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              PrimaryFilledButtonTwo(
                                text: "Hire",
                                onPressed: () => _navigateToHiringForm(context),
                              ),
                              const SizedBox(height: 10),
                              // Icons section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconButton(
                                    icon: Icons.phone,
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 20),
                                  CustomIconButton(
                                    icon: Icons.chat,
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 20),
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
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: const Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(150, 255, 255, 255),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              BadgeWidget(icon: Icons.star, label: "Hero"),
                              BadgeWidget(
                                  icon: Icons.flash_on, label: "Superman"),
                              BadgeWidget(icon: Icons.speed, label: "Quicker"),
                              BadgeWidget(
                                  icon: Icons.verified, label: "Trustabler"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Stats Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatWidget(
                            label: 'Completed Works',
                            value: completedWorks.toString()),
                        StatWidget(label: 'Customer Reviews', value: '85+'),
                      ],
                    ),

                    // Gallery Section
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gallery',
                              style: kTitleTextStyle,
                            ),
                            const SizedBox(height: 10),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children:
                                  List.generate(imagePaths.length, (index) {
                                return FullScreenImage(
                                  imagePath: imagePaths[index],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
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

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seyoni/src/config/route.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/constants_font.dart';
import 'components/menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  Future<Map<String, String>> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('seekerId') ?? '',
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'email': prefs.getString('email') ?? '',
      'profileImageUrl': prefs.getString('profileImageUrl') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userDetails = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 180, // Adjusted height to fit both containers
                  child: Stack(
                    clipBehavior: Clip.none, // To allow overflow positioning
                    children: [
                      // Background Container
                      Container(
                        height:
                            120, // Original height for the main profile container
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          border: const Border(
                            bottom: BorderSide(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: userDetails['profileImageUrl']!
                                      .startsWith('http')
                                  ? NetworkImage(
                                      userDetails['profileImageUrl']!)
                                  : FileImage(
                                          File(userDetails['profileImageUrl']!))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kPrimaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    '${userDetails['firstName']} ${userDetails['lastName']}',
                                    style: kAppBarTitleTextStyle),
                                Text('${userDetails['email']}',
                                    style: kBodyTextStyle),
                                Text('Profile Complete: 67%',
                                    style: kBodyTextStyle),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                    context, AppRoutes.editProfile);
                                if (result == true) {
                                  // Refresh the user details
                                  setState(() {});
                                }
                              },
                              icon: Image.asset(
                                'assets/icons/forms/Edit.png',
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Overlapping Container (Box on top)
                      Positioned(
                        top: 100, // Adjusted position to overlap
                        left: 30,
                        right: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: const Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(150, 255, 255, 255),
                                width: 1,
                              ),
                            ),
                          ),
                          height: 75,
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: const Color.fromARGB(15, 255, 255, 255),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                                'assets/icons/menu/Siren.png',
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.cover)),
                                        Text('Emergency',
                                            style: kBodyTextStyle2),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                                'assets/icons/menu/Bookmark.png',
                                                height: 35,
                                                width: 35,
                                                fit: BoxFit.cover)),
                                        Text('Bookmark',
                                            style: kBodyTextStyle2),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                                'assets/icons/menu/Invite.png',
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.cover)),
                                        Text('Invite', style: kBodyTextStyle2),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // General Settings
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text('General Settings', style: kAppBarTitleTextStyle),
                ),
                MenuItem(
                  iconPath: 'assets/icons/menu/Settings.png',
                  text: 'My Orders',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/FastCart.png',
                  text: 'My Cart',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/history.png',
                  text: 'Order History',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),

                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/reward.png',
                  text: 'Refferal Rewards',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 20),
                // Account Settings
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child:
                        Text('Account Settings', style: kAppBarTitleTextStyle)),
                MenuItem(
                  iconPath: 'assets/icons/menu/Settings.png',
                  text: 'Personal Details',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Logout.png',
                  text: 'Change Password',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Translator.png',
                  text: 'Change Language',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Notification.png',
                  text: 'Notification Preferences',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/authentication.png',
                  text: 'Two-Factor Authentication',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Delete.png',
                  text: 'Delete Account',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 20),
                // Account Settings
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text('Payment', style: kAppBarTitleTextStyle)),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/add_payment.png',
                  text: 'Add Payment Method',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Payment_History.png',
                  text: 'Payment History',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/manage_payment.png',
                  text: 'Manage Payment Methods',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 20),
                // Account Settings
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text('Favourite Location',
                        style: kAppBarTitleTextStyle)),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Home.png',
                  text: 'Add Home',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Business.png',
                  text: 'Add Work',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/saved_location.png',
                  text: 'Saved Locations',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/d_location.png',
                  text: 'Set default location',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 20),
                // Account Settings
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text('Support', style: kAppBarTitleTextStyle)),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/about_us.png',
                  text: 'About Us',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/privacy_policy.png',
                  text: 'Privacy Policy',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/t&c.png',
                  text: 'Terms & Conditions',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/live_chat.png',
                  text: 'Live Chat',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/feedback.png',
                  text: 'Feedback',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Star.png',
                  text: 'Rate Us',
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
                const SizedBox(height: 10),
                MenuItem(
                  iconPath: 'assets/icons/menu/Star.png',
                  text: 'Become a Provider',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.providerSignUp);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

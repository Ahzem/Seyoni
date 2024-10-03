import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import '../../constants/constants_font.dart';
import './components/menu_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  height: 120, // Original height for the main profile container
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
                      Image.asset(
                        'assets/icons/forms/Profile.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text('Mark Antony', style: kAppBarTitleTextStyle),
                          Text('markantony@gmail.com', style: kBodyTextStyle),
                          Text('Profile Complete: 67%', style: kBodyTextStyle),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          // Add your onPressed logic here
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/icons/menu/Siren.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover)),
                                  Text('Emergency', style: kBodyTextStyle2),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          'assets/icons/menu/Bookmark.png',
                                          height: 35,
                                          width: 35,
                                          fit: BoxFit.cover)),
                                  Text('Bookmark', style: kBodyTextStyle2),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
            iconPath: 'assets/icons/menu/Info.png',
            text: 'About Us',
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
          const SizedBox(height: 10),
          MenuItem(
            iconPath: 'assets/icons/menu/Privacy.png',
            text: 'Emergency Contacts',
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
          const SizedBox(height: 20),
          // Account Settings
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Text('Account Settings', style: kAppBarTitleTextStyle)),
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
            iconPath: 'assets/icons/menu/CreditCard.png',
            text: 'Add Card',
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
          const SizedBox(height: 10),
          MenuItem(
            iconPath: 'assets/icons/menu/Logout.png',
            text: 'Log Out',
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ],
      ),
    );
  }
}

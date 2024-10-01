import 'package:flutter/material.dart';
import 'dart:ui'; // Import this for ImageFilter
import 'components/image_path.dart';
import '../../constants/constants_color.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), // Apply blur effect
        child: Container(
          color: const Color.fromARGB(255, 0, 0, 0)
              .withOpacity(0.3), // Adjust the opacity as needed
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            currentIndex: widget.currentIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kPrimaryColor.withOpacity(0.65),
            onTap: widget.onTap,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  taskOutlined,
                  height: 30,
                  width: 30,
                ),
                activeIcon: Image.asset(
                  taskFilled,
                  height: 30,
                  width: 30,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  chatOutlined,
                  height: 30,
                  width: 30,
                ),
                activeIcon: Image.asset(
                  chatFilled,
                  height: 30,
                  width: 30,
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  homeOutlined,
                  height: 30,
                  width: 30,
                ),
                activeIcon: Image.asset(
                  homeFilled,
                  height: 30,
                  width: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  categoryOutlined,
                  height: 30,
                  width: 30,
                ),
                activeIcon: Image.asset(
                  categoryFilled,
                  height: 30,
                  width: 30,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  profileOutlined,
                  height: 30,
                  width: 30,
                ),
                activeIcon: Image.asset(
                  profileFilled,
                  height: 30,
                  width: 30,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

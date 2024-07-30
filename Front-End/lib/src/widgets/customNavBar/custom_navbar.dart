import 'package:flutter/material.dart';
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
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        currentIndex: widget.currentIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kPrimaryColor.withOpacity(0.7),
        onTap: widget.onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
            label: '',
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
            label: '',
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
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              walletOutlined,
              height: 30,
              width: 30,
            ),
            activeIcon: Image.asset(
              walletFilled,
              height: 30,
              width: 30,
            ),
            label: '',
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
            label: '',
          ),
        ],
      ),
    );
  }
}

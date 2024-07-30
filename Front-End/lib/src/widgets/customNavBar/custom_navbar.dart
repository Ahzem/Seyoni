import 'package:flutter/material.dart';
import '../../constants/constants_color.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: kTransparentColor,
      currentIndex: widget.currentIndex,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kPrimaryColor.withOpacity(0.7),
      onTap: widget.onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined, size: 30),
          activeIcon: Icon(Icons.calendar_today, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined, size: 30),
          activeIcon: Icon(Icons.message, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 30),
          activeIcon: Icon(Icons.home_rounded, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wallet_outlined, size: 30),
          activeIcon: Icon(Icons.wallet, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 30),
          activeIcon: Icon(Icons.person, size: 30),
          label: '',
        ),
      ],
    );
  }
}

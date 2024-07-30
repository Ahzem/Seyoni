import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/customNavBar/custom_navbar.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
        child: Text(
            'Tasks Page Content')), // Replace with your actual page widgets
    const Center(child: Text('Chat Page Content')),
    const Center(child: Text('Home Page Content')),
    const Center(child: Text('Wallet Page Content')),
    const Center(child: Text('Profile Page Content')),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}

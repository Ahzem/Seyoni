import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/customNavBar/custom_navbar.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_font.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../menu/menupage.dart';

class HomePage extends StatefulWidget {
  final String? token;
  const HomePage({super.key, this.token});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Map<String, dynamic> _decodedToken;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _decodedToken = JwtDecoder.decode(widget.token!);
    } else {
      _decodedToken = {}; // Handle the case where token is null
    }
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Text(
        'Tasks Page Content',
        style: kBodyTextStyle,
      ),
    ),
    const Center(
      child: Text(
        'Chat Page Content',
        style: kBodyTextStyle,
      ),
    ),
    const Center(
      child: Text(
        'Home Page Content',
        style: kBodyTextStyle,
      ),
    ),
    const Center(
      child: Text(
        'Category Page Content',
        style: kBodyTextStyle,
      ),
    ),
    const Center(child: MenuPage()),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          appBar: const CustomAppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_decodedToken.isNotEmpty)
                    Text(
                      'Welcome, ${_decodedToken['name'] ?? 'User'}',
                      style: kBodyTextStyle,
                    ),
                  _pages[_currentIndex],
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavBarTapped,
          ),
        ),
      ],
    );
  }
}

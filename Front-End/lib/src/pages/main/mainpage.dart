import 'package:flutter/material.dart';
import 'package:seyoni/src/pages/chat/chat_page.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission handler package
import '../../pages/profiles/provider/seeker_view.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/customNavBar/custom_navbar.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_font.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../category/category_page.dart';
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
    _currentIndex = 2;

    // Call the function to check permissions
    _checkPermissions();
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(),
    const Center(child: ChatScreen()),
    const Center(
      child: Text(
        'Home Page Content',
        style: kBodyTextStyle,
      ),
    ),
    const Center(child: CategoryPage()),
    const Center(child: MenuPage()),
  ];

  // Function to check and request necessary permissions
  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.microphone,
      Permission.camera,
      Permission.location,
    ].request();

    // Handle denied permissions (example: showing an alert for denied permissions)
    if (statuses[Permission.storage]?.isDenied ?? false) {
      _showPermissionAlert("Storage");
    }

    if (statuses[Permission.microphone]?.isDenied ?? false) {
      _showPermissionAlert("Microphone");
    }

    if (statuses[Permission.camera]?.isDenied ?? false) {
      _showPermissionAlert("Camera");
    }

    if (statuses[Permission.location]?.isDenied ?? false) {
      _showPermissionAlert("Location");
    }
  }

  // Function to show an alert when permission is denied
  void _showPermissionAlert(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$permissionName Permission Required"),
        content: Text(
            "Please grant $permissionName permission to use this feature."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings if the user wants to enable permission manually
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

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

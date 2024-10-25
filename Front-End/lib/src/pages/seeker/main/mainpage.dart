import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission handler package
import 'package:seyoni/src/pages/seeker/home/home.dart';
import 'package:seyoni/src/pages/seeker/order-history/order_history_page.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/customNavBar/custom_navbar.dart';
import '../../../widgets/background_widget.dart';
import '../category/category_page.dart';
import '../chat/chat_page.dart';
import '../menu/menupage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Initialize _currentIndex to a valid index

  @override
  void initState() {
    super.initState();

    // Call the function to check permissions
    _checkPermissions();
  }

  final List<Widget> _pages = [
    const OrderHistoryPage(),
    const ChatScreen(),
    const HomeCenterPage(),
    const CategoryPage(),
    const MenuPage(),
  ];

  // Function to check and request necessary permissions
  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.location,
    ].request();

    // Handle denied permissions (example: showing an alert for denied permissions)
    if (statuses[Permission.storage]?.isDenied ?? false) {
      _showPermissionAlert("Storage");
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
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await SystemNavigator.pop();
      },
      child: Stack(
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
                    _pages[
                        _currentIndex], // Display the page based on _currentIndex
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: onNavBarTapped,
            ),
          ),
        ],
      ),
    );
  }
}

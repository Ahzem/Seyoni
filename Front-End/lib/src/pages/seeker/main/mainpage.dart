import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission handler package
import 'package:provider/provider.dart';
import 'package:seyoni/src/pages/seeker/home/home.dart';
import 'package:seyoni/src/pages/seeker/order-history/order_history_page.dart';
import 'package:seyoni/src/pages/seeker/sign-pages/signin_page.dart';
import 'package:seyoni/src/widgets/draggable_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/customNavBar/custom_navbar.dart';
import '../../../widgets/background_widget.dart';
import '../category/category_page.dart';
import '../chat/chat_page.dart';
import '../menu/menupage.dart';
import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    const OrderHistoryPage(),
    const ChatScreen(),
    const HomeCenterPage(),
    const CategoryPage(),
    const MenuPage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthAndInit();
    // Override the back button behavior
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        // Prevent the app from closing
        return Future.value();
      }
    });
  }

  Future<void> _checkAuthAndInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? seekerId = prefs.getString('seekerId');
    String? token = prefs.getString('token');

    if (seekerId == null || token == null || JwtDecoder.isExpired(token)) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
      return;
    }

    if (mounted) {
      debugPrint('Initializing NotificationProvider for seeker: $seekerId');
      final provider =
          Provider.of<NotificationProvider>(context, listen: false);
      await provider.ensureConnection();
      await provider.identifyUser(seekerId, 'seeker');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissions();
    });
  }

  Future<void> _initializeWebSocketConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final seekerId = prefs.getString('seekerId');
    if (seekerId != null && mounted) {
      final provider =
          Provider.of<NotificationProvider>(context, listen: false);
      await provider.ensureConnection();
      await provider.identifyUser(seekerId, 'seeker');
    }
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.location,
    ].request();

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
              openAppSettings();
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
  void dispose() {
    // Reset the back button behavior
    SystemChannels.platform.setMethodCallHandler(null);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Prevent the app from navigating back
    return false;
  }

  // mainpage.dart
  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Background Layer
              const Positioned.fill(
                child: BackgroundWidget(child: SizedBox.expand()),
              ),

              // Main Content Layer
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: const CustomAppBar(),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pages[_currentIndex],
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: onNavBarTapped,
                ),
              ),

              // Draggable Button Layer - On top
              Consumer<NotificationProvider>(
                builder: (context, provider, _) {
                  debugPrint(
                      'Building draggable button. isVisible: ${provider.isVisible}, otp: ${provider.otp}');
                  if (provider.isVisible && provider.otp.isNotEmpty) {
                    return DraggableOtpButton();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

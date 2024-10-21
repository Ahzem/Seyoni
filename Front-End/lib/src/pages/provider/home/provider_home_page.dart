import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/pages/provider/accepted/accepted_reservations_page.dart';
import 'package:seyoni/src/pages/provider/new/new_requests_page.dart';
import 'package:seyoni/src/pages/provider/rejected/rejected_reservations_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import '../login/provider_signin_page.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  ProviderHomePageState createState() => ProviderHomePageState();
}

class ProviderHomePageState extends State<ProviderHomePage> {
  List<dynamic> reservations = [];
  bool isLoading = true;
  String errorMessage = '';
  String providerName = '';
  String profileImageUrl = '';
  String proffession = '';
  int acceptedCount = 0;
  int rejectedCount = 0;
  int newRequestsCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    _fetchProviderDetails();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchReservations();
    });
  }

  Future<void> _fetchReservations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');

      if (providerId == null || providerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(getReservationsUrl),
        headers: {
          'provider-id': providerId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> allReservations = json.decode(response.body);
        setState(() {
          reservations = allReservations.where((reservation) {
            return reservation['providerId'] == providerId;
          }).toList();
          acceptedCount = reservations
              .where((reservation) => reservation['status'] == 'accepted')
              .length;
          rejectedCount = reservations
              .where((reservation) => reservation['status'] == 'rejected')
              .length;
          newRequestsCount = reservations
              .where((reservation) => reservation['status'] == 'pending')
              .length;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load reservations: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load reservations: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProviderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');

      if (providerId == null || providerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$url/api/providers/$providerId'),
      );

      if (response.statusCode == 200) {
        final provider = json.decode(response.body);
        setState(() {
          providerName = provider['lastName'];
          profileImageUrl = provider['profileImageUrl'];
          proffession = provider['proffession'];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load provider details: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load provider details: $e';
      });
    }
  }


  Future<void> updateReservationStatus(
      String reservationId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      if (providerId == null || providerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
        });
        return;
      }

      final response = await http.patch(
        Uri.parse('$url/api/reservations/$reservationId/$status'),
        headers: {
          'Content-Type': 'application/json',
          'provider-id': providerId,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          reservations = reservations.map((reservation) {
            if (reservation['_id'] == reservationId) {
              reservation['status'] = status;
            }
            return reservation;
          }).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update reservation: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update reservation: $e';
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProviderSignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Image.asset(
            'assets/images/logo.png',
            height: height * 0.05,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: kPrimaryColor),
              onPressed: _logout,
            ),
          ],
          automaticallyImplyLeading: false, // Remove back arrow
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Blurred Profile Card
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : const AssetImage('assets/images/profile-3.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $providerName',
                                style: kSubtitleTextStyle,
                              ),
                              Text(
                                '$proffession',
                                style: kSubtitleTextStyle,
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: kPrimaryColor),
                          onPressed: () {
                            // Navigate to Notifications Page
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Summary Card
              Card(
                color: kPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Reservations',
                        style: kTitleTextStyle,
                      ),
                      Text(
                        '${reservations.length}',
                        style: kTitleTextStyleBold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Profile and Settings Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryFilledButton(
                    text: 'Profile',
                    onPressed: () {
                      // Navigate to Profile Page
                    },
                  ),
                  PrimaryFilledButton(
                    text: 'Settings',
                    onPressed: () {
                      // Navigate to Settings Page
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // GridView for Reservations
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    _buildBlurredContainer(
                      context,
                      'Accepted Reservations',
                      Icons.check_circle,
                      const AcceptedReservationsPage(),
                      acceptedCount,
                    ),
                    _buildBlurredContainer(
                      context,
                      'Rejected Reservations',
                      Icons.cancel,
                      const RejectedReservationsPage(),
                      rejectedCount,
                    ),
                    _buildBlurredContainer(
                      context,
                      'New Requests',
                      Icons.new_releases,
                      const NewRequestsPage(),
                      newRequestsCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBlurredContainer(
    BuildContext context, String title, IconData icon, Widget page, int count) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(title,
                    style: kSubtitleTextStyle, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/pages/provider/accepted/accepted_reservations_page.dart';
import 'package:seyoni/src/pages/provider/new/new_requests_page.dart';
import 'package:seyoni/src/pages/provider/rejected/rejected_reservations_page.dart'; // Add this line
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import '../login/provider_signin_page.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/pages/provider/provider_profilepage.dart'; // Ensure this import is correct

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
  String profession = '';
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
        if (mounted) {
          setState(() {
            errorMessage = 'User not logged in';
            isLoading = false;
          });
        }
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
        if (mounted) {
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
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load reservations: ${response.body}';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load reservations: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchProviderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');

      if (providerId == null || providerId.isEmpty) {
        if (mounted) {
          setState(() {
            errorMessage = 'User not logged in';
            isLoading = false;
          });
        }
        return;
      }

      final response = await http.get(
        Uri.parse('$url/api/provider/$providerId'),
      );

      if (response.statusCode == 200) {
        final provider = json.decode(response.body);
        if (mounted) {
          setState(() {
            providerName = provider['lastName'];
            profileImageUrl = provider['profileImageUrl'];
            profession = provider['profession'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load provider details: ${response.body}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load provider details: $e';
        });
      }
    }
  }

  Future<void> updateReservationStatus(
      String reservationId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      if (providerId == null || providerId.isEmpty) {
        if (mounted) {
          setState(() {
            errorMessage = 'User not logged in';
          });
        }
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
        if (mounted) {
          setState(() {
            reservations = reservations.map((reservation) {
              if (reservation['_id'] == reservationId) {
                reservation['status'] = status;
              }
              return reservation;
            }).toList();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to update reservation: ${response.body}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to update reservation: $e';
        });
      }
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
              const SizedBox(height: 20),
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildSummaryCard(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryOutlinedButton(
                    text: 'Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProviderProfilepage()),
                      );
                    },
                  ),
                  PrimaryOutlinedButton(
                    text: 'Settings',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildReservationCard(
                        context,
                        'Accepted Reservations',
                        Icons.check_circle,
                        const AcceptedReservationsPage(),
                        acceptedCount,
                      ),
                      _buildReservationCard(
                        context,
                        'Rejected Reservations',
                        Icons.cancel,
                        const RejectedReservationsPage(),
                        rejectedCount,
                      ),
                      _buildReservationCard(
                        context,
                        'New Requests',
                        Icons.new_releases,
                        const NewRequestsPage(),
                        newRequestsCount,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
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
                      style: kSubtitleTextStyle.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      profession,
                      style: kSubtitleTextStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.white, width: 1), // Border color and width
        borderRadius: BorderRadius.circular(12), // Same radius as the Card
      ),
      child: Card(
        color: kContainerColor.withOpacity(0.2),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
                style: kTitleTextStyleBold.copyWith(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, String title,
      IconData icon, Widget page, int count) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: kAccentColor, width: 0.8),
          color: kPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: kAccentColor,
              child: Icon(
                icon,
                size: 30,
                color: title == 'Accepted Reservations'
                    ? Colors.green
                    : title == 'Rejected Reservations'
                        ? Colors.red
                        : Colors.yellow,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: kSubtitleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You have $count ${title.toLowerCase()}',
                    style: kSubtitleTextStyle.copyWith(
                        fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            if (count > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kAccentColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 0.2),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

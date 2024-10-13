import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import '../login/provider_signin_page.dart';
import 'reservation_detail_page.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      print('Retrieved providerId: $providerId');

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

  void _viewReservation(Map<String, dynamic> reservation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationDetailPage(reservation: reservation),
      ),
    );
  }

  Future<void> _updateReservationStatus(
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
      MaterialPageRoute(builder: (context) => ProviderSignInPage()),
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
          title: const Text('Provider Home Page', style: kAppBarTitleTextStyle),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: kPrimaryColor),
              onPressed: _logout,
            ),
          ],
          automaticallyImplyLeading: false, // Remove back arrow
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'assets/images/logo-icon.png',
                height: height * 0.1,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // Summary Card
              Card(
                color: kPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              // Reservations List
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(child: Text(errorMessage))
                        : ListView.builder(
                            itemCount: reservations.length,
                            itemBuilder: (context, index) {
                              final reservation = reservations[index];
                              return Card(
                                color: kContainerColor,
                                child: ListTile(
                                  title: Text(
                                    reservation['serviceType'],
                                    style: kCardTitleTextStyle,
                                  ),
                                  subtitle: Text(
                                    '${reservation['description'].toString().split(' ').take(12).join(' ')}...',
                                    style: kCardTextStyle,
                                  ),
                                  trailing: PrimaryFilledButtonThree(
                                    text: 'View Request',
                                    onPressed: () =>
                                        _viewReservation(reservation),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

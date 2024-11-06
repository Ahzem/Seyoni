import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seyoni/src/config/route.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/url.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, dynamic>> providers = [];
  List<dynamic> seekers = [];

  @override
  void initState() {
    super.initState();
    _fetchProviders();
    _fetchSeekers();
  }

  Future<void> _fetchSeekers() async {
    try {
      final response = await http.get(Uri.parse(getSeekersUrl));
      if (response.statusCode == 200) {
        setState(() {
          seekers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _fetchProviders() async {
    final response = await http.get(Uri.parse(fetchProvidersUrl));
    if (response.statusCode == 200) {
      setState(() {
        providers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      // Handle error
    }
  }

  Future<void> updateProviderStatus(String id, bool isApproved) async {
    final response = await http.post(
      Uri.parse('$updateProviderStatusUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'isApproved': isApproved}),
    );

    if (response.statusCode == 200) {
      _fetchProviders();
    } else {
      // Handle error
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, AppRoutes.providerSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kPrimaryColor),
            onPressed: _logout,
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Admin!',
                style: kTitleTextStyle.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 20),
              _buildSummaryCard(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAdminCard(
                        context,
                        'Manage Seekers',
                        Icons.people,
                        AppRoutes.listOfSeekers,
                        '${seekers.length}',
                        'Total registered seekers',
                      ),
                      const SizedBox(height: 16),
                      _buildAdminCard(
                        context,
                        'Manage Providers',
                        Icons.business,
                        AppRoutes.listOfProviders,
                        '${providers.where((p) => p['isApproved'] == true).length}',
                        'Approved service providers',
                      ),
                      const SizedBox(height: 16),
                      _buildAdminCard(
                        context,
                        'Provider Registration Requests',
                        Icons.app_registration,
                        AppRoutes.listOfRegistrationRequests,
                        '${providers.where((p) => p['isApproved'] == false).length}',
                        'Pending approval requests',
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

  Widget _buildSummaryCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kContainerColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: kTitleTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Users: ${providers.length + seekers.length}',
                style: kBodyTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon,
      String route, String count, String subtitle) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kAccentColor, width: 0.8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: kAccentColor,
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: kSubtitleTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: kBodyTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kAccentColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 0.2),
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

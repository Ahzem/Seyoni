import 'package:flutter/material.dart';
import 'package:seyoni/src/config/route.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config/url.dart';
import '../../widgets/custom_button.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, dynamic>> providers = [];

  @override
  void initState() {
    super.initState();
    _fetchProviders();
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

  Future<void> _updateProviderStatus(String id, bool isApproved) async {
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
        backgroundColor: kPrimaryColor,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // Replace with your logo path
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  children: [
                    _buildBlurredContainer(
                      context,
                      'Manage Seekers',
                      Icons.people,
                      AppRoutes.listOfSeekers,
                    ),
                    _buildBlurredContainer(
                      context,
                      'Manage Providers',
                      Icons.business,
                      AppRoutes.listOfProviders,
                    ),
                    _buildBlurredContainer(
                      context,
                      'Provider Registration Request',
                      Icons.app_registration,
                      AppRoutes.listOfRegistrationRequests,
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

  Widget _buildBlurredContainer(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(title, style: kTitleTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}

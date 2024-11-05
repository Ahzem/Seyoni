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
        automaticallyImplyLeading: false, // Remove the back button
        backgroundColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // Replace with your logo path
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
            children: [
                Align(
                alignment: Alignment.centerLeft,
                child: Text('Hello, Admin!', style: kTitleTextStyle,),
                ),
              const SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCard(Icons.person, 'Registered Providers', '${providers.length}'),
                    buildCard(Icons.person, 'Registration Requests', '${providers.length}'),
                  ],
                ),
             const SizedBox(height: 20),
              Expanded(
                child: ListView(
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
                      'Provider Registration Requests',
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

  Widget buildCard(IconData icon, String title, String count) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Card(
        elevation: 4,
        color: kContainerColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(75.0), // Set to half of height/width to make it round
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white), // Add user icon
              SizedBox(height: 8), // Spacing between icon and text
              Text(
                title,
                style: kBodyTextStyle,
                textAlign: TextAlign.center,
              ),
              Text(count, style: kBodyTextStyle),
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
          color: kPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  SizedBox(width: 20),
                  Text(title, style: kSubtitleTextStyle2, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}

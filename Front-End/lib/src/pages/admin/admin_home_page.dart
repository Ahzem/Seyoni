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
    // logout logic
    // For example, clear user session and navigate to login page
    Navigator.pushReplacementNamed(context, AppRoutes.providerSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Admin Home Page'),
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
                child: ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return Card(
                      color: kPrimaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Name: ${provider['firstName']} ${provider['lastName']}',
                                style: kSubtitleTextStyle),
                            Text('Email: ${provider['email']}',
                                style: kSubtitleTextStyle),
                            Text('Phone: ${provider['phone']}',
                                style: kSubtitleTextStyle),
                            Text('Location: ${provider['location']}',
                                style: kSubtitleTextStyle),
                            Text('Category: ${provider['category']}',
                                style: kSubtitleTextStyle),
                            Text(
                                'Subcategories: ${provider['subCategories'].join(', ')}',
                                style: kSubtitleTextStyle),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PrimaryFilledButtonTwo(
                                  text: 'Approve',
                                  onPressed: () => _updateProviderStatus(
                                      provider['_id'], true),
                                ),
                                PrimaryFilledButtonTwo(
                                  text: 'Reject',
                                  onPressed: () => _updateProviderStatus(
                                      provider['_id'], false),
                                ),
                              ],
                            ),
                          ],
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

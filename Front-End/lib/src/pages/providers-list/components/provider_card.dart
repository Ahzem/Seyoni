import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../profiles/provider/seeker_view.dart';
import '../../forms/hiring_form.dart';
import '../../../config/url.dart';

class ProviderCard extends StatelessWidget {
  final String providerId;
  final String name;
  final String imageUrl;
  final double rating;
  final String profession;
  final int completedWorks;
  final bool isAvailable;

  const ProviderCard({
    super.key,
    required this.providerId,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.profession,
    required this.completedWorks,
    required this.isAvailable,
  });

  Future<Map<String, dynamic>> fetchProviderDetails(String providerId) async {
    final response =
        await http.get(Uri.parse('$url/api/providers/$providerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load provider details: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to load provider details');
    }
  }

  void _navigateToSeekerView(BuildContext context, String providerId) async {
    print('Navigating to seeker view for provider: $providerId');
    try {
      final providerDetails = await fetchProviderDetails(providerId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeekerView(providerDetails: providerDetails),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load provider details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToHiringForm(BuildContext context, String providerId) async {
    print('Navigating to hiring form for provider: $providerId');
    try {
      final providerDetails = await fetchProviderDetails(providerId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HiringForm(
            name: providerDetails['name'],
            profileImage: providerDetails['imageUrl'],
            rating: providerDetails['rating'],
            serviceType: providerDetails['category'],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load provider details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.8))),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: imageUrl.isNotEmpty
                          ? AssetImage(imageUrl)
                          : AssetImage(
                              'assets/images/profile-3.jpg'), // Fallback image
                      radius: 35,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? Colors.green
                              : Colors.red, // Availability color
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: kPrimaryColor,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Rating: $rating',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: kPrimaryColor,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Completed Works: $completedWorks',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 12,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            profession,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            _navigateToSeekerView(context, providerId),
                        child: Text(
                          'View',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            _navigateToHiringForm(context, providerId),
                        child: Text(
                          'Hire',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

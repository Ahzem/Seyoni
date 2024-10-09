import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'dart:ui';
import 'provider_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../profiles/provider/seeker_view.dart';
import '../../forms/hiring_form.dart';

class ProviderCard extends StatelessWidget {
  final ProviderData provider;

  const ProviderCard({super.key, required this.provider});

  Future<Map<String, dynamic>> fetchProviderDetails(String providerId) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/providers/$providerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load provider details');
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
                      backgroundImage: provider.imageUrl.isNotEmpty
                          ? AssetImage(provider.imageUrl)
                          : AssetImage(
                              'assets/images/profile-1.jpg'), // Fallback image
                      radius: 35,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: provider.isAvailable
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
                        provider.name,
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
                            'Rating: ${provider.rating}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        'Completed Works: ${provider.completedWorks}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        provider.profession,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
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
                        onPressed: () async {
                          try {
                            final providerDetails =
                                await fetchProviderDetails(provider.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeekerView(
                                  providerDetails: providerDetails,
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Failed to load provider details'),
                                backgroundColor: kPrimaryColor,
                              ),
                            );
                          }
                        },
                        child: const Text('View',
                            style: TextStyle(color: Colors.white)),
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
                        onPressed: () async {
                          try {
                            final providerDetails =
                                await fetchProviderDetails(provider.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HiringForm(
                                  name: providerDetails['name'],
                                  profileImage: providerDetails['profileImage'],
                                  rating: providerDetails['rating'],
                                  serviceType: providerDetails['serviceType'],
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Failed to load provider details'),
                                backgroundColor: kPrimaryColor,
                              ),
                            );
                          }
                        },
                        child: const Text('Hire',
                            style: TextStyle(color: Colors.white)),
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

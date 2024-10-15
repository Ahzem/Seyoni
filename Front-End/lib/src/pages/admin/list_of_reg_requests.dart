import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import '../../config/url.dart';
import 'provider_details.dart';

class ListOfRegistrationRequests extends StatefulWidget {
  const ListOfRegistrationRequests({super.key});

  @override
  ListOfRegistrationRequestsState createState() =>
      ListOfRegistrationRequestsState();
}

class ListOfRegistrationRequestsState
    extends State<ListOfRegistrationRequests> {
  List<Map<String, dynamic>> providers = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      final response = await http.get(Uri.parse(getProvidersUrl));
      if (response.statusCode == 200) {
        setState(() {
          providers = List<Map<String, dynamic>>.from(jsonDecode(response.body))
              .where((provider) =>
                  provider['isApproved'] == false &&
                  provider['email'] != 'seyoni@admin.com')
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load providers ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load providers: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToProviderDetails(String providerId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderDetails(providerId: providerId),
      ),
    );

    if (result == true) {
      _fetchProviders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Provider Registration Requests',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: providers.length,
                      itemBuilder: (context, index) {
                        final provider = providers[index];
                        final fullName =
                            '${provider['firstName'] ?? 'N/A'} ${provider['lastName'] ?? 'N/A'}';
                        final email = provider['email'] ?? 'N/A';
                        final location = provider['location'] ?? 'N/A';
                        return Card(
                          color: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    provider['profileImageUrl'] ??
                                        'https://via.placeholder.com/150',
                                  ),
                                  radius: 30,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName,
                                      style: kSubtitleTextStyle2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      email,
                                      style: kBodyTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      location,
                                      style: kBodyTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.visibility,
                                      color: Colors.white),
                                  onPressed: () {
                                    _navigateToProviderDetails(provider['_id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

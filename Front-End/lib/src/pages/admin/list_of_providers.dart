import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/constants/constants_color.dart';
import 'dart:convert';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import '../../config/url.dart';

class ListOfProviders extends StatefulWidget {
  const ListOfProviders({super.key});

  @override
  ListOfProvidersState createState() => ListOfProvidersState();
}

class ListOfProvidersState extends State<ListOfProviders> {
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
                  provider['isApproved'] == true &&
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
            title: const Text('Service Providers',
                style: kSubtitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(
                color: kPrimaryColor,
              ))
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
                      final fullName = '${provider['firstName'] ?? 'N/A'} ${provider['lastName'] ?? 'N/A'}';
                      final email = provider['email'] ?? 'N/A';
                      return Card(
                        color: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      provider['profileImageUrl'] ?? 'https://via.placeholder.com/150',
                                    ),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fullName,
                                          style: kCardTitleTextStyle,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          email,
                                          style: kBodyTextStyle,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to manage provider page
                                  },
                                  child: const Text(
                                    'Manage',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )


        ),
      ],
    );
  }
}

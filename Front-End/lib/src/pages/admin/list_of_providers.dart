import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/constants_color.dart';
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
          providers =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
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
            title: const Text('List of Providers',
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
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: providers.length,
                      itemBuilder: (context, index) {
                        final provider = providers[index];
                        return Card(
                          color: kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(provider['profileImageUrl']),
                                  radius: 30,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    'Name: ${provider['firstName']} ${provider['lastName']}',
                                    style: kSubtitleTextStyle),
                                Text('Email: ${provider['email']}',
                                    style: kSubtitleTextStyle),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to manage provider page
                                  },
                                  child: const Text('Manage',
                                      style: TextStyle(color: Colors.white)),
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/constants_color.dart';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import '../../config/url.dart';

class ListOfSeekers extends StatefulWidget {
  const ListOfSeekers({super.key});

  @override
  ListOfSeekersState createState() => ListOfSeekersState();
}

class ListOfSeekersState extends State<ListOfSeekers> {
  List<Map<String, dynamic>> seekers = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSeekers();
  }

  Future<void> _fetchSeekers() async {
    try {
      final response = await http.get(Uri.parse(getSeekersUrl));
      if (response.statusCode == 200) {
        setState(() {
          seekers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load seekers ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load seekers: $e';
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
            title: const Text('List of Seekers',
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
                      itemCount: seekers.length,
                      itemBuilder: (context, index) {
                        final seeker = seekers[index];
                        final fullName =
                            '${seeker['firstName'] ?? 'N/A'} ${seeker['lastName'] ?? 'N/A'}';
                        final email = seeker['email'] ?? 'N/A';
                        return Card(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    seeker['profileImageUrl'] ??
                                        'https://via.placeholder.com/150',
                                  ),
                                  radius: 30,
                                ),
                                const SizedBox(height: 10),
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
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to manage seeker page
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

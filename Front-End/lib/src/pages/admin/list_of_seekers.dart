import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/constants/constants_color.dart';
import 'dart:convert';
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
      if (getSeekersUrl.isEmpty || getSeekersUrl == 'N/A') {
        throw Exception('Invalid API URL');
      }

      final response = await http.get(Uri.parse(getSeekersUrl));

      if (response.statusCode == 200) {
        setState(() {
          seekers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load seekers: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
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
            title: const Text('Service Seekers', style: kSubtitleTextStyle2),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
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
                      itemCount: seekers.length,
                      itemBuilder: (context, index) {
                        final seeker = seekers[index];
                        final fullName =
                            '${seeker['firstName'] ?? 'N/A'} ${seeker['lastName'] ?? 'N/A'}';
                        final email = seeker['email'] ?? 'N/A';
                        return Card(
                          color: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    seeker['profileImageUrl'] ??
                                        'https://via.placeholder.com/150',
                                  ),
                                  radius: 30,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () {
                                            // Navigate to manage seeker page
                                          },
                                          child: const Text(
                                            'Manage',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/pages/provider/new/new_reservation_detail_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/no_reservations_widget.dart';

class NewRequestsPage extends StatefulWidget {
  const NewRequestsPage({super.key});

  @override
  NewRequestsPageState createState() => NewRequestsPageState();
}

class NewRequestsPageState extends State<NewRequestsPage> {
  List<dynamic> reservations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');

      if (providerId == null || providerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(getReservationsUrl),
        headers: {
          'provider-id': providerId,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> allReservations = json.decode(response.body);
        setState(() {
          reservations = allReservations.where((reservation) {
            return reservation['providerId'] == providerId &&
                reservation['status'] == 'pending';
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load reservations: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load reservations: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:
              const Text('New Requests', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: kPrimaryColor,
              ))
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : reservations.isEmpty
                    ? const NoReservationsWidget(message: 'No new reservations')
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          final seeker = reservation['seeker'];
                          final seekerLastName = seeker['lastName'] ?? 'N/A';
                          final description = reservation['description']
                              .toString()
                              .split(' ')
                              .take(8)
                              .join(' ');

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              seeker['profileImageUrl'] ??
                                                  'https://via.placeholder.com/150',
                                            ),
                                            radius: 30,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                seekerLastName,
                                                style: kCardTitleTextStyle,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                reservation['serviceType']
                                                    .toString()
                                                    .substring(0, 12),
                                                style: kCardTextStyle,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        description,
                                        style: kBodyTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const Spacer(),
                                      Center(
                                        child: TextButton(
                                          onPressed: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewReservationDetailPage(
                                                  reservationId:
                                                      reservation['_id'],
                                                ),
                                              ),
                                            );
                                            if (result == true) {
                                              _fetchReservations();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Text('View Request',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

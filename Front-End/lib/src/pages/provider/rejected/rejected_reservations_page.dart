import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/pages/provider/rejected/rejected_reservation_detail_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/no_reservations_widget.dart';

class RejectedReservationsPage extends StatefulWidget {
  const RejectedReservationsPage({super.key});

  @override
  RejectedReservationsPageState createState() =>
      RejectedReservationsPageState();
}

class RejectedReservationsPageState extends State<RejectedReservationsPage> {
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
                reservation['status'] == 'rejected';
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
          title: const Text('Rejected Reservations',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
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
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 16),
                    ),
                  )
                : reservations.isEmpty
                    ? const NoReservationsWidget(
                        message: 'No rejected reservations')
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
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

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundImage: seeker[
                                                            'profileImageUrl'] !=
                                                        null &&
                                                    seeker['profileImageUrl']
                                                        .toString()
                                                        .isNotEmpty &&
                                                    seeker['profileImageUrl'] !=
                                                        "N/A"
                                                ? NetworkImage(
                                                    seeker['profileImageUrl'])
                                                : const AssetImage(
                                                        'assets/images/profile-1.jpg')
                                                    as ImageProvider,
                                            backgroundColor: Colors.grey[300],
                                            onBackgroundImageError: (e, s) {
                                              debugPrint(
                                                  'Error loading profile image: $e');
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  seekerLastName,
                                                  style: kCardTitleTextStyle
                                                      .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  reservation['serviceType']
                                                      .toString()
                                                      .substring(0, 12),
                                                  style:
                                                      kCardTextStyle.copyWith(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  description,
                                                  style:
                                                      kBodyTextStyle.copyWith(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RejectedReservationDetailPage(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: const Text(
                                                'View',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}

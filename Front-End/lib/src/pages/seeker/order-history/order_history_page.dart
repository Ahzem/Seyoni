import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/url.dart';
import '../../../widgets/background_widget.dart';
import '../forms/order_view.dart';
import 'components/history_card.dart';
import '../../../constants/constants_font.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
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
      String? seekerId = prefs.getString('seekerId');
      if (seekerId == null || seekerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final url = getReservationsUrl;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'seeker-id': seekerId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          reservations = json.decode(response.body);
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

  String _getStatusMessage(String status) {
    switch (status) {
      case 'accepted':
        return 'Request has been accepted';
      case 'rejected':
        return 'Request has been rejected';
      case 'pending':
      default:
        return 'Request is pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (errorMessage.isNotEmpty)
          Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )
        else
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Order History',
                      style: kAlertTitleTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: reservations.map((reservation) {
                      return HistoryCard(
                        providerName: reservation['name'] ?? '',
                        profileImage: reservation['profileImage'] ?? '',
                        profession: reservation['profession'] ?? '',
                        date: reservation['date'] ?? '',
                        time: reservation['time'] ?? '',
                        status: reservation['status'] ?? 'pending',
                        onTrack: () {
                          // Implement track logic
                        },
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderView(
                                name: reservation['name'] ?? '',
                                profileImage: reservation['profileImage'] ?? '',
                                rating:
                                    reservation['rating']?.toDouble() ?? 0.0,
                                profession: reservation['profession'] ?? '',
                                location: reservation['location'] ?? '',
                                time: reservation['time'] ?? '',
                                date: reservation['date'] ?? '',
                                description: reservation['description'] ?? '',
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          // Implement delete logic
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

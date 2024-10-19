import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import 'reservation_detail_page.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';

class AcceptedReservationsPage extends StatefulWidget {
  const AcceptedReservationsPage({super.key});

  @override
  AcceptedReservationsPageState createState() =>
      AcceptedReservationsPageState();
}

class AcceptedReservationsPageState extends State<AcceptedReservationsPage> {
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
                reservation['status'] == 'accepted';
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

  void _viewReservation(Map<String, dynamic> reservation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationDetailPage(reservation: reservation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:
              const Text('Accepted Reservations', style: kAppBarTitleTextStyle),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        return Card(
                          color: kContainerColor,
                          child: ListTile(
                            title: Text(
                              reservation['serviceType'],
                              style: kCardTitleTextStyle,
                            ),
                            subtitle: Text(
                              '${reservation['description'].toString().split(' ').take(12).join(' ')}...',
                              style: kCardTextStyle,
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _viewReservation(reservation),
                              child: const Text('View'),
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
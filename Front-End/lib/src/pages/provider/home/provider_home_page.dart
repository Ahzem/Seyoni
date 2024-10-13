import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import 'reservation_detail_page.dart';
import 'package:seyoni/src/widgets/custom_button.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  ProviderHomePageState createState() => ProviderHomePageState();
}

class ProviderHomePageState extends State<ProviderHomePage> {
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
      print('Retrieved providerId: $providerId');

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
            return reservation['providerId'] == providerId;
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

  Future<void> _updateReservationStatus(
      String reservationId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      if (providerId == null || providerId.isEmpty) {
        setState(() {
          errorMessage = 'User not logged in';
        });
        return;
      }

      final response = await http.patch(
        Uri.parse('$url/api/reservations/$reservationId/$status'),
        headers: {
          'Content-Type': 'application/json',
          'provider-id': providerId,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          reservations = reservations.map((reservation) {
            if (reservation['_id'] == reservationId) {
              reservation['status'] = status;
            }
            return reservation;
          }).toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update reservation: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update reservation: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Home Page'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    return Card(
                      child: ListTile(
                        title: Text(reservation['serviceType']),
                        subtitle: Text(
                          '${reservation['description'].toString().split(' ').take(12).join(' ')}...',
                        ),
                        trailing: PrimaryFilledButtonThree(
                          text: 'View Request',
                          onPressed: () => _viewReservation(reservation),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

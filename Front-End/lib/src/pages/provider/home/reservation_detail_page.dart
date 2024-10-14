import 'package:flutter/material.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';

class ReservationDetailPage extends StatefulWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetailPage({super.key, required this.reservation});

  @override
  ReservationDetailPageState createState() => ReservationDetailPageState();
}

class ReservationDetailPageState extends State<ReservationDetailPage> {
  late Map<String, dynamic> reservation;

  @override
  void initState() {
    super.initState();
    reservation = widget.reservation;
  }

  Future<void> _updateReservationStatus(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      if (providerId == null || providerId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not logged in'),
            backgroundColor: kErrorColor,
          ),
        );
        return;
      }

      final response = await http.patch(
        Uri.parse('$url/api/reservations/${reservation['_id']}/$status'),
        headers: {
          'Content-Type': 'application/json',
          'provider-id': providerId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          reservation['status'] = status;
        });
        if (status == 'rejected') {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update reservation: ${response.body}'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update reservation: $e'),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Reservation Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${reservation['seeker']['firstName']} ${reservation['seeker']['lastName']}',
                style: kTitleTextStyle,
              ),
              Text(
                'Service: ${reservation['serviceType']}',
                style: kSubtitleTextStyle,
              ),
              Text(
                'Description: ${reservation['description']}',
                style: kBodyTextStyle,
              ),
              Text(
                'Time: ${reservation['time']}',
                style: kBodyTextStyle,
              ),
              Text(
                'Date: ${reservation['date']}',
                style: kBodyTextStyle,
              ),
              Text(
                'Location: ${reservation['location']}',
                style: kBodyTextStyle,
              ),
              if (reservation['images'] != null &&
                  reservation['images'].isNotEmpty)
                Column(
                  children: reservation['images'].map<Widget>((image) {
                    return Image.network(image);
                  }).toList(),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryFilledButtonTwo(
                    text: reservation['status'] == 'accepted'
                        ? 'Track'
                        : 'Accept',
                    onPressed: () {
                      if (reservation['status'] == 'accepted') {
                        // Navigate to tracking page
                      } else {
                        _updateReservationStatus('accept');
                      }
                    },
                  ),
                  PrimaryFilledButtonTwo(
                    text: reservation['status'] == 'rejected'
                        ? 'Delete'
                        : 'Reject',
                    onPressed: () {
                      if (reservation['status'] == 'rejected') {
                        // Handle delete action
                        Navigator.pop(context);
                      } else {
                        _updateReservationStatus('reject');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

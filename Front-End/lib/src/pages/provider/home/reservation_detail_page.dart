import 'package:flutter/material.dart';
import 'package:seyoni/src/config/url.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class ReservationDetailPage extends StatefulWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetailPage({required this.reservation, Key? key})
      : super(key: key);

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  String readableAddress = '';
  bool isAccepted = false;

  @override
  void initState() {
    super.initState();
    _getReadableAddress();
  }

  Future<void> _getReadableAddress() async {
    try {
      final locationString = widget.reservation['location'] ?? '';
      final latLng = locationString
          .substring(
            locationString.indexOf('(') + 1,
            locationString.indexOf(')'),
          )
          .split(', ');
      final latitude = double.parse(latLng[0]);
      final longitude = double.parse(latLng[1]);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        readableAddress =
            '${place.street}, ${place.locality}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        readableAddress = 'Unknown location';
      });
    }
  }

  Future<void> _updateReservationStatus(String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? providerId = prefs.getString('providerId');
      if (providerId == null || providerId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in'),
            backgroundColor: kErrorColor,
          ),
        );
        return;
      }

      final url = status == 'accepted'
          ? '$acceptReservationUrl/${widget.reservation['_id']}/accept'
          : '$rejectReservationUrl/${widget.reservation['_id']}/reject';

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'provider-id': providerId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.reservation['status'] = status;
          if (status == 'accepted') {
            isAccepted = true;
          } else if (status == 'rejected') {
            Navigator.pop(context, true); // Pass true to indicate rejection
          }
        });
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

  void _showConfirmationDialog(String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this reservation?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateReservationStatus(
                    action == 'accept' ? 'accepted' : 'rejected');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final seeker = widget.reservation['seeker'] ?? {};
    final profileImage = seeker['profileImage'] ?? '';
    final name = widget.reservation['name'] ?? 'Unknown';
    final date = widget.reservation['date'] ?? 'Unknown';
    final time = widget.reservation['time'] ?? 'Unknown';
    final description = widget.reservation['description'] ?? 'No description';

    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Reservation Details',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Display seeker's profile picture
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                // Display reservation details with icons
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Text(name, style: kTitleTextStyle),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Text(readableAddress, style: kSubtitleTextStyle),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(date, style: kSubtitleTextStyle),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text(time, style: kSubtitleTextStyle),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Description', style: kSubtitleTextStyle),
                const SizedBox(height: 8),
                Text(description, style: kBodyTextStyle),
                const SizedBox(height: 16),
                // Display images with curves
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.reservation['images']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final imageUrl =
                          widget.reservation['images'][index] ?? '';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                imageUrl: imageUrl,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(imageUrl),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Accept and Reject buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (isAccepted) {
                          // Logic for tracking
                        } else {
                          _showConfirmationDialog('accept');
                        }
                      },
                      child: Text(isAccepted ? 'Track' : 'Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog('reject');
                      },
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

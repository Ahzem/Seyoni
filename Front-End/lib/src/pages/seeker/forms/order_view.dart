import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/route.dart';
import '../../../config/url.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../profiles/components/icon_button_widget.dart';
import 'components/service_provider_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderView extends StatefulWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String profession;
  final String location;
  final String time;
  final String date;
  final String description;

  const OrderView({
    super.key,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.profession,
    required this.location,
    required this.time,
    required this.date,
    required this.description,
  });

  @override
  OrderViewState createState() => OrderViewState();
}

class OrderViewState extends State<OrderView> {
  List<dynamic> _reservations = [];

  String get requestStatus {
    return _reservations.isEmpty
        ? 'pending'
        : 'accepted'; // Adjust the logic as needed
  }

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final url = Uri.parse(getReservationsUrl);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? seekerId = prefs.getString('seekerId');

      if (seekerId == null) {
        throw Exception('Seeker ID is not available');
      }

      final response = await http.get(
        url,
        headers: {
          'seeker-id': seekerId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _reservations = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      throw Exception('Failed to load reservations');
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
            title: const Text('Order View', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.home);
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceProviderInfo(
                        name: widget.name,
                        profileImage: widget.profileImage,
                        rating: widget.rating,
                        profession: widget.profession,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 22, color: kPrimaryColor),
                                SizedBox(width: 10),
                                Text(
                                  widget.location,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 22, color: kPrimaryColor),
                                SizedBox(width: 10),
                                Text(
                                  widget.time,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.date_range,
                                    size: 22, color: kPrimaryColor),
                                SizedBox(width: 10),
                                Text(
                                  widget.date,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.description,
                                    size: 22, color: kPrimaryColor),
                                SizedBox(width: 10),
                                Text(
                                  'Description',
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.description,
                              style: kBodyTextStyle,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (requestStatus == 'pending') ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                kPrimaryColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Request is pending',
                                                  style:
                                                      kReservationsTitleTextStyle),
                                              SizedBox(width: 10),
                                              Icon(Icons.change_circle,
                                                  size: 26,
                                                  color: kPrimaryColor),
                                            ],
                                          ),
                                        ),
                                      ] else if (requestStatus ==
                                          'accepted') ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                kSuccessColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Request has been accepted',
                                                  style:
                                                      kReservationsTitleTextStyle),
                                              SizedBox(width: 10),
                                              Icon(Icons.check_circle,
                                                  size: 26,
                                                  color: kSuccessColor),
                                            ],
                                          ),
                                        ),
                                      ] else if (requestStatus ==
                                          'rejected') ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: kErrorColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Request has been rejected',
                                                  style:
                                                      kReservationsTitleTextStyle),
                                              SizedBox(width: 10),
                                              Icon(Icons.cancel,
                                                  size: 26, color: kErrorColor),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                  icon: Icons.phone,
                                  onPressed: () {},
                                ),
                                SizedBox(width: 30),
                                CustomIconButton(
                                  icon: Icons.chat,
                                  onPressed: () {},
                                ),
                                SizedBox(width: 30),
                                CustomIconButton(
                                  icon: Icons.bookmark_added_sharp,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import '../../config/route.dart';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import 'components/service_provider_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderView extends StatefulWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String serviceType;
  final String location;
  final String time;
  final String date;
  final String description;

  const OrderView({
    super.key,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.serviceType,
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

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/reservations'));

    if (response.statusCode == 200) {
      setState(() {
        _reservations = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load reservations.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
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
                        serviceType: widget.serviceType,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 24, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(
                            widget.location,
                            style: kTitleTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 24, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(
                            widget.time,
                            style: kTitleTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.date_range,
                              size: 24, color: kPrimaryColor),
                          SizedBox(width: 10),
                          Text(
                            widget.date,
                            style: kTitleTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            'Description',
                            style: kTitleTextStyle,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.description,
                            style: kBodyTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Reservations',
                        style: kTitleTextStyle,
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = _reservations[index];
                          return ListTile(
                            title: Text(reservation['name']),
                            subtitle: Text(reservation['description']),
                          );
                        },
                      ),
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

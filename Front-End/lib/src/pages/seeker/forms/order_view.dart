import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import '../../../config/route.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../profiles/components/icon_button_widget.dart';
import 'components/service_provider_info.dart';

class OrderView extends StatefulWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String profession;
  final String location;
  final String time;
  final String date;
  final String description;
  final String status;

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
    required this.status,
  });

  @override
  OrderViewState createState() => OrderViewState();
}

class OrderViewState extends State<OrderView> {
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
                      const SizedBox(height: 20),
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
                                const Icon(Icons.location_on,
                                    size: 22, color: kPrimaryColor),
                                const SizedBox(width: 10),
                                Text(
                                  widget.location,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 22, color: kPrimaryColor),
                                const SizedBox(width: 10),
                                Text(
                                  widget.time,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    size: 22, color: kPrimaryColor),
                                const SizedBox(width: 10),
                                Text(
                                  widget.date,
                                  style: kReservationsTitleTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
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
                            const SizedBox(height: 10),
                            Text(
                              widget.description,
                              style: kBodyTextStyle,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (widget.status == 'pending') ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                kPrimaryColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Row(
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
                                      ] else if (widget.status ==
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
                                          child: const Row(
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
                                      ] else if (widget.status ==
                                          'rejected') ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: kErrorColor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Row(
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                  icon: Icons.phone,
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 30),
                                CustomIconButton(
                                  icon: Icons.chat,
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 30),
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

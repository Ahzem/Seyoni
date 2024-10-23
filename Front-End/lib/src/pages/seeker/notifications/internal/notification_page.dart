import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../constants/constants_font.dart';
import '../../../../constants/constants_color.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final notifications =
        Provider.of<NotificationProvider>(context).notifications;

    return Stack(
      children: [
        // Background image
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        // Main content with app bar and bottom navigation bar
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Notifications', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white.withOpacity(0.8))),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: kPrimaryColor,
                            size: 35,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: kCardTitleTextStyle,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  notification.message,
                                  style: kCardTextStyle,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  notification.timestamp.toString(),
                                  style: kCardTextStyle,
                                ),
                              ],
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
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../constants/constants_font.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final List<Widget> notifications = [
    // Replace with your actual page widgets
    const Center(
      child: Text(
        'Notification Page Content',
        style: kBodyTextStyle,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          body: ListView(
            children: notifications,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/background_widget.dart';
import '../../../constants/constants_font.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          appBar: const CustomAppBar(),
          body: ListView(
            children: notifications,
          ),
        ),
      ],
    );
  }
}

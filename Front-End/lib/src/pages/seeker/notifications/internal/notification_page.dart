import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../constants/constants_font.dart';

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
            title: Text('Notifications', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notifications[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

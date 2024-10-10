import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/constants_font.dart';
import '../../../constants/constants_color.dart';
import '../../../widgets/custom_button.dart';

class HistoryCard extends StatelessWidget {
  final String providerName;
  final String profileImage;
  final String profession;
  final String date;
  final String time;
  final String status;
  final VoidCallback onTrack;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.providerName,
    required this.profileImage,
    required this.profession,
    required this.date,
    required this.time,
    required this.status,
    required this.onTrack,
    required this.onView,
    required this.onDelete,
  });

  ImageProvider getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      try {
        return AssetImage(imageUrl);
      } catch (e) {
        print('Error loading image: $e');
        return AssetImage('assets/images/profile-3.jpg'); // Fallback image
      }
    } else {
      return AssetImage('assets/images/profile-3.jpg'); // Fallback image
    }
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('d MMM yyyy');
    return formatter.format(parsedDate);
  }

  String _formatTime(String time) {
    // Extract the time from the TimeOfDay string format
    final timeString = time.replaceAll(RegExp(r'[^\d:]'), '');
    final TimeOfDay parsedTime = TimeOfDay(
      hour: int.parse(timeString.split(":")[0]),
      minute: int.parse(timeString.split(":")[1]),
    );
    final DateTime now = DateTime.now();
    final DateTime formattedTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(formattedTime);
  }

  @override
  Widget build(BuildContext context) {
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
                bottom: BorderSide(color: Colors.white.withOpacity(0.8)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: getImageProvider(profileImage),
                  radius: 35,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(providerName, style: kSubtitleTextStyle2),
                      Text(profession, style: kBodyTextStyle),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatDate(date), style: kBodyTextStyle),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatTime(time), style: kBodyTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (status == 'accepted')
                      Row(
                        children: [
                          PrimaryFilledButton(
                            text: 'Track',
                            onPressed: onTrack,
                          ),
                        ],
                      )
                    else if (status == 'rejected')
                      Row(
                        children: [
                          PrimaryFilledButton(
                            text: 'Delete',
                            onPressed: onDelete,
                          ),
                        ],
                      )
                    else if (status == 'pending')
                      Row(
                        children: [
                          PrimaryFilledInactiveButton(
                            text: 'Track',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    const SizedBox(width: 5),
                    PrimaryFilledButtonThree(
                      text: 'View',
                      onPressed: onView,
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

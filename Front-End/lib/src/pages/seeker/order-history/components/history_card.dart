import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/constants_font.dart';
import '../../../../constants/constants_color.dart';
import '../../../../widgets/custom_button.dart';

class HistoryCard extends StatelessWidget {
  final String providerName;
  final String profileImage;
  final String profession;
  final String date;
  final String time;
  final String status; // accepted, rejected, pending
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
        return NetworkImage(imageUrl);
      } catch (e) {
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

  // Method to return the correct status icon
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.help;
    }
  }

  // Method to return the correct status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green.withOpacity(0.6);
      case 'rejected':
        return Colors.red.withOpacity(0.6);
      case 'pending':
        return Colors.orange.withOpacity(0.6);
      default:
        return Colors.grey.withOpacity(0.6);
    }
  }

  // Method to return the correct status text
  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  // Method to return the correct status icon color
  Color _getStatusIconColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: getImageProvider(profileImage),
                      radius: 35,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 3),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(status),
                              color: _getStatusIconColor(status),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _getStatusText(status),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(providerName, style: kCardTitleTextStyle),
                      Text(profession, style: kCardTextStyle),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatDate(date), style: kCardTextStyle),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatTime(time), style: kCardTextStyle),
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
                          PrimaryFilledButtonThree(
                            text: 'Track',
                            onPressed: onTrack,
                          ),
                        ],
                      )
                    else if (status == 'rejected')
                      Row(
                        children: [
                          PrimaryFilledButtonThree(
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
                    PrimaryOutlinedButtonTwo(
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

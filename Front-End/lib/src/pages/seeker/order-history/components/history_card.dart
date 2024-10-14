import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/constants_font.dart';
import '../../../../constants/constants_color.dart';
import '../../../../widgets/custom_button.dart';

class HistoryCard extends StatelessWidget {
  final Map<String, dynamic> reservation;
  final VoidCallback onTrack;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.reservation,
    required this.onTrack,
    required this.onView,
    required this.onDelete,
  });

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        return NetworkImage(imageUrl);
      } catch (e) {
        return const AssetImage(
            'assets/images/profile-3.jpg'); // Fallback image
      }
    } else {
      return const AssetImage('assets/images/profile-3.jpg'); // Fallback image
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
                      backgroundImage:
                          getImageProvider(reservation['profileImage']),
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
                          color: _getStatusColor(reservation['status']),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(reservation['status']),
                              color: _getStatusIconColor(reservation['status']),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _getStatusText(reservation['status']),
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
                      Text(reservation['name'] ?? '',
                          style: kCardTitleTextStyle),
                      Text(reservation['profession'] ?? '',
                          style: kCardTextStyle),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatDate(reservation['date'] ?? ''),
                              style: kCardTextStyle),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: kParagraphTextColor),
                          const SizedBox(width: 4),
                          Text(_formatTime(reservation['time'] ?? ''),
                              style: kCardTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (reservation['status'] == 'accepted')
                      Row(
                        children: [
                          PrimaryFilledButtonThree(
                            text: 'Track',
                            onPressed: onTrack,
                          ),
                        ],
                      )
                    else if (reservation['status'] == 'rejected')
                      Row(
                        children: [
                          PrimaryFilledButtonThree(
                            text: 'Delete',
                            onPressed: onDelete,
                          ),
                        ],
                      )
                    else if (reservation['status'] == 'pending')
                      Row(
                        children: [
                          PrimaryFilledInactiveButtonThree(
                            text: 'Track',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
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

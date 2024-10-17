import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

class ServiceProviderInfo extends StatelessWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String profession;

  const ServiceProviderInfo({
    super.key,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(profileImage),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: kTitleTextStyle.copyWith(fontSize: 20),
            ),
            Text(profession, style: kBodyTextStyle),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: kPrimaryColor,
                );
              }),
            ),
          ],
        )
      ],
    );
  }
}

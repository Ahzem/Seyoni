import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/pages/provider/profile/edit_profile.dart';
import 'dart:ui';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({super.key});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  final List<Map<String, dynamic>> services = [
    {
      'name': 'Basic Plumbing',
      'price': '5000',
      'duration': '1 hour',
      'description': 'Basic plumbing repairs and maintenance',
    },
    {
      'name': 'Emergency Service',
      'price': '10000',
      'duration': '1 hour',
      'description': '24/7 emergency plumbing services',
    },
  ];

  List<File> galleryImages = [
    File('assets/images/work1.jpg'),
    File('assets/images/work2.jpg'),
    File('assets/images/work3.jpg'),
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        galleryImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(File image) {
    setState(() {
      galleryImages.remove(image);
    });
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
            title: const Text('Business Profile', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildMetricsSection(),
                  const SizedBox(height: 16),
                  _buildGallerySection(),
                  const SizedBox(height: 16),
                  _buildServicesList(),
                  const SizedBox(height: 16),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem('Jobs\nCompleted', '156'),
          _buildMetricItem('Active\nWorkers', '8'),
          _buildMetricItem('Avg\nRating', '4.8'),
          _buildMetricItem('Years\nActive', '5'),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: kSubtitleTextStyle2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildServicesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Services Offered', style: kSubtitleTextStyle),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service['name'], style: kBodyTextStyle),
                        Text(
                          service['description'],
                          style: kSubtitleTextStyle2,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${service['price']}/hr',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        service['duration'],
                        style: kSubtitleTextStyle2,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gallery', style: kSubtitleTextStyle),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: galleryImages.length + 1,
            itemBuilder: (context, index) {
              if (index == galleryImages.length) {
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.add_photo_alternate, color: kPrimaryColor),
                  ),
                );
              }
              final image = galleryImages[index];
              return Stack(
                children: [
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(image),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Reviews', style: kSubtitleTextStyle),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < 4 ? kPrimaryColor : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Client ${index + 1}', style: kBodyTextStyle),
                        Text(
                          '${5 - index}.0 ★',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Great service! Very professional and timely.',
                      style: kSubtitleTextStyle2,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile-3.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'John\'s Plumbing Services',
                style: kTitleTextStyleBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Professional Plumbing Solutions',
                style: kSubtitleTextStyle2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 20,
                    color: index < 4 ? kPrimaryColor : Colors.grey,
                  ),
                ),
              ),
              const Text(
                '4.8 (156 Reviews)',
                style: kBodyTextStyle,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildContactButton(
                    icon: Icons.phone,
                    label: 'Call',
                    onTap: () {
                      // Implement call functionality
                    },
                  ),
                  _buildContactButton(
                    icon: Icons.message,
                    label: 'Message',
                    onTap: () {
                      // Implement message functionality
                    },
                  ),
                  _buildContactButton(
                    icon: Icons.location_on,
                    label: 'Location',
                    onTap: () {
                      // Implement location functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kPrimaryColor),
          ),
          const SizedBox(height: 4),
          Text(label, style: kSubtitleTextStyle2),
        ],
      ),
    );
  }
}
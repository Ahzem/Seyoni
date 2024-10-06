import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'dart:io';
import '../../constants/constants_color.dart';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';

class HiringForm extends StatefulWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String serviceType;

  const HiringForm({
    super.key,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.serviceType,
  });

  @override
  HiringFormState createState() => HiringFormState();
}

class HiringFormState extends State<HiringForm> {
  File? _selectedImage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      barrierColor: Colors.black.withOpacity(0.7),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildGoogleMap() {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(6.927079, 79.861244), // Default location (Colombo)
          zoom: 14,
        ),
        onTap: (LatLng latLng) {
          // Handle location selection
        },
      ),
    );
  }

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
            title: const Text('Hiring Form', style: kAppBarTitleTextStyle),
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Provider Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage(widget.profileImage), // Profile image
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: kTitleTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(widget.serviceType, style: kBodyTextStyle),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < widget.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: kPrimaryColor,
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),

                  // Location Field
                  _buildGoogleMap(),
                  SizedBox(height: 20),

                  // Date Picker
                  Row(
                    children: [
                      // Date Picker with Blur Background
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.4))),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Icon(Icons.date_range,
                                      size: 24, color: kPrimaryColor),
                                  SizedBox(width: 5),
                                  TextButton(
                                    onPressed: _pickDate,
                                    child: Text(
                                      _selectedDate != null
                                          ? _selectedDate
                                              .toString()
                                              .split(' ')[0]
                                          : "Pick a date",
                                      style: kBodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      // Time Picker with Blur Background
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.4))),
                        ),
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 24, color: kPrimaryColor),
                                  SizedBox(width: 5),
                                  TextButton(
                                    onPressed: _pickTime,
                                    child: Text(
                                      _selectedTime != null
                                          ? _selectedTime!.format(context)
                                          : "Pick a time",
                                      style: kBodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Image Picker
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.4))),
                        ),
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Column(
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 24, color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: _pickImage,
                                    child: Text(
                                      "Add Image",
                                      style: kBodyTextStyle,
                                    ),
                                  ),
                                  if (_selectedImage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.file(
                                        _selectedImage!,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      // Record Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.4))),
                        ),
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Column(
                                children: [
                                  Icon(Icons.mic,
                                      size: 24, color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Record",
                                      style: kBodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Text Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.white.withOpacity(0.4))),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          color: Colors.white.withOpacity(0.1),
                          child: TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.message, color: kPrimaryColor),
                              hintText: "Enter your message",
                              hintStyle: kBodyTextStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            style: kBodyTextStyle,
                            maxLines: 5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PrimaryOutlinedButton(text: "Cancel", onPressed: () {}),
                      PrimaryFilledButton(text: "Reserve", onPressed: () {}),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

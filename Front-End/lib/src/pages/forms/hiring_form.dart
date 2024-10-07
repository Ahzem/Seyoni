import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import 'components/service_provider_info.dart';
import 'components/google_map_widget.dart';
import 'components/date_picker.dart';
import 'components/time_picker.dart';
import 'components/image_picker.dart';
import 'components/record_field.dart';
import 'components/text_field.dart';
import 'components/buttons.dart';

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
                  ServiceProviderInfo(
                    name: widget.name,
                    profileImage: widget.profileImage,
                    rating: widget.rating,
                    serviceType: widget.serviceType,
                  ),
                  SizedBox(height: 20),
                  GoogleMapWidget(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      DatePicker(
                        selectedDate: _selectedDate,
                        onPickDate: _pickDate,
                      ),
                      SizedBox(width: 10),
                      TimePicker(
                        selectedTime: _selectedTime,
                        onPickTime: _pickTime,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ImagePickerWidget(
                        selectedImage: _selectedImage,
                        onPickImage: _pickImage,
                      ),
                      SizedBox(width: 10),
                      RecordField(
                        onRecord: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextField(),
                  SizedBox(width: 20),
                  Buttons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

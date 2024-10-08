import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import '../../constants/constants_font.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_button.dart';
import '../profiles/provider/components/icon_button_widget.dart';
import 'components/service_provider_info.dart';
import 'components/google_map_widget.dart';
import 'components/date_picker.dart';
import 'components/time_picker.dart';
import 'components/image_picker.dart';
import 'components/text_field.dart';
import '../../widgets/alertbox/unsaved_changes.dart';
import '../../widgets/alertbox/reservation_confirmation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'order_view.dart';

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
  List<File> _selectedImages = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _selectedLocation;
  String? _enteredAddress; // Add this line
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<GoogleMapWidgetState> _googleMapKey =
      GlobalKey<GoogleMapWidgetState>();

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only add up to 3 images.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
      barrierColor: Colors.black.withOpacity(0.7),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // Reset the selected time if the date is changed
        _selectedTime = null;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      // Ensure the selected time is not in the past if the selected date is today
      if (_selectedDate != null &&
          _selectedDate!.isAtSameMomentAs(DateTime.now())) {
        if (picked.hour < now.hour ||
            (picked.hour == now.hour && picked.minute < now.minute)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Please select a future time.',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: kPrimaryColor),
          );
          return;
        }
      }
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _pickLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _enterAddress(String address) {
    setState(() {
      _enteredAddress = address;
    });
  }

  Future<void> _confirmReservation() async {
    if (_selectedDate == null ||
        _selectedTime == null ||
        (_selectedLocation == null &&
            (_enteredAddress == null || _enteredAddress!.isEmpty)) ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
        ),
      );
      return;
    }

    final reservationData = {
      'name': widget.name,
      'profileImage': widget.profileImage,
      'rating': widget.rating,
      'serviceType': widget.serviceType,
      'location': _selectedLocation?.toString() ?? _enteredAddress!,
      'time': _selectedTime.toString(),
      'date': _selectedDate.toString(),
      'description': _descriptionController.text,
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/api/reservations'),
    );

    request.fields.addAll(
        reservationData.map((key, value) => MapEntry(key, value.toString())));

    for (var image in _selectedImages) {
      var mimeType = lookupMimeType(image.path);
      var mimeTypeData = mimeType?.split('/');
      if (mimeTypeData != null && mimeTypeData.length == 2) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderView(
            name: widget.name,
            profileImage: widget.profileImage,
            rating: widget.rating,
            serviceType: widget.serviceType,
            location: _selectedLocation?.toString() ?? _enteredAddress!,
            time: _selectedTime.toString(),
            date: _selectedDate.toString(),
            description: _descriptionController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save reservation.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => UnsavedChanges(
        onContinueEditing: () {
          Navigator.of(ctx).pop();
        },
        onLeave: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void showReservationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ReservationConfirmation(
        onContinueEditing: () {
          Navigator.of(ctx).pop();
        },
        onConfirm: () {
          Navigator.of(ctx).pop(); // Close the dialog
          _confirmReservation(); // Call the method to confirm reservation
        },
      ),
    );
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
              onPressed: _showUnsavedChangesDialog,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
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
                      GoogleMapWidget(
                        key: _googleMapKey,
                        initialLocation: _selectedLocation,
                        onLocationPicked: _pickLocation,
                        onClearLocation: () =>
                            _googleMapKey.currentState?.clearLocation(),
                        onAddressEntered: _enterAddress, // Add this line
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPickImage: _pickImage,
                          ),
                          SizedBox(width: 10),
                          SelectedImagesWidget(selectedImages: _selectedImages),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomTextField(controller: _descriptionController),
                      SizedBox(height: 5),
                      // Clear form text button including custom text description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedImages = [];
                                _selectedDate = null;
                                _selectedTime = null;
                                _selectedLocation = null;
                                _enteredAddress = null; // Add this line
                                _descriptionController.clear();
                                _googleMapKey.currentState
                                    ?.clearLocation(); // Clear the location field
                              });
                            },
                            child: Row(
                              children: [
                                Text('Clear Form',
                                    style: kBodyTextStyle,
                                    textAlign: TextAlign.right),
                                SizedBox(width: 5),
                                Icon(Icons.clear_all, color: kPrimaryColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            icon: Icons.phone,
                            onPressed: () {},
                          ),
                          SizedBox(width: 30),
                          CustomIconButton(
                            icon: Icons.chat,
                            onPressed: () {},
                          ),
                          SizedBox(width: 30),
                          CustomIconButton(
                            icon: Icons.bookmark_added_sharp,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryOutlinedButton(
                                text: "Cancel",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            SizedBox(width: 10),
                            PrimaryFilledButton(
                                text: "Reserve",
                                onPressed: showReservationConfirmationDialog),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

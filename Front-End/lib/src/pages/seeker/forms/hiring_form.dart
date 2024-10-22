import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import '../../../config/url.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../../../widgets/custom_button.dart';
import '../profiles/components/icon_button_widget.dart';
import 'components/service_provider_info.dart';
import 'components/google_map_widget.dart';
import 'components/date_picker.dart';
import 'components/time_picker.dart';
import 'components/image_picker.dart';
import 'components/text_field.dart';
import '../../../widgets/alertbox/unsaved_changes.dart';
import '../../../widgets/alertbox/reservation_confirmation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'order_view.dart';

class HiringForm extends StatefulWidget {
  final String name;
  final String profileImage;
  final double rating;
  final String profession;
  final String serviceType;
  final String providerId;

  const HiringForm({
    super.key,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.profession,
    required this.serviceType,
    required this.providerId,
  });

  @override
  HiringFormState createState() => HiringFormState();
}

class HiringFormState extends State<HiringForm> {
  List<File> _selectedImages = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _selectedLocation;
  String? _enteredAddress;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _confirmReservation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? seekerId = prefs.getString('seekerId');
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');
    String? email = prefs.getString('email');

    // Debug prints to verify field values

    if (_selectedDate == null ||
        _selectedTime == null ||
        (_selectedLocation == null &&
            (_enteredAddress == null || _enteredAddress!.isEmpty)) ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please fill all the required fields before confirming the reservation.',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
      ));
      return;
    }

    if (seekerId == null ||
        firstName == null ||
        lastName == null ||
        email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve seeker details.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
        ),
      );
      return;
    }

    var reservationData = {
      'name': widget.name,
      'profileImage': widget.profileImage,
      'rating': widget.rating,
      'profession': widget.profession,
      'serviceType': widget.serviceType,
      'location': _selectedLocation != null
          ? '${_selectedLocation!.latitude},${_selectedLocation!.longitude}'
          : _enteredAddress!,
      'time': _selectedTime!.format(context),
      'date': _selectedDate.toString(),
      'description': _descriptionController.text,
      'seeker': {
        'id': seekerId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      },
      'providerId': widget.providerId,
    };

    var request = http.MultipartRequest('POST', Uri.parse(sendReservationsUrl));
    request.headers['seeker-id'] = seekerId; // Add seeker ID to headers
    request.headers['provider-id'] =
        widget.providerId; // Add provider ID to headers

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
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderView(
            name: widget.name,
            profileImage: widget.profileImage,
            rating: widget.rating,
            profession: widget.profession,
            location: _selectedLocation != null
                ? '${_selectedLocation!.latitude},${_selectedLocation!.longitude}'
                : _enteredAddress!,
            time: _selectedTime!.format(context), // Format the time correctly
            date: _selectedDate.toString(),
            description: _descriptionController.text,
            status: 'pending',
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save reservation.',
              style: TextStyle(color: Colors.black)),
          backgroundColor: kPrimaryColor,
        ),
      );
    }
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      }
    } catch (e) {
      // Handle the error, e.g., show a message to the user
      print(
          'Error occurred while getting address from latitude and longitude: $e');
    }
    // Return latitude and longitude as a fallback
    return '${position.latitude},${position.longitude}';
  }

  void pickLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _enteredAddress = null; // Clear entered address when location is picked
    });
  }

  void enterAddress(String address) {
    setState(() {
      _enteredAddress = address;
      _selectedLocation =
          null; // Clear selected location when address is entered
    });
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
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
          Navigator.of(ctx).pop();

          _confirmReservation();
        },
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
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
                  profession: widget.profession,
                ),
                const SizedBox(height: 20),
                CustomLocationField(
                  controller: _locationController,
                  labelText: 'Location',
                  onTap: () async {
                    final result =
                        await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const GoogleMapsBottomSheet(),
                      ),
                    );
                    if (result != null) {
                      final address = result['address'] as String;
                      final latitude = result['latitude'] as double;
                      final longitude = result['longitude'] as double;
                      if (address.isNotEmpty) {
                        setState(() {
                          _locationController.text = address;
                          _selectedLocation = LatLng(latitude, longitude);
                          _enteredAddress = address;
                        });
                      } else {
                        // Handle the case where the address is empty
                        print('Address is empty');
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DatePicker(
                      selectedDate: _selectedDate,
                      onPickDate: _pickDate,
                    ),
                    const SizedBox(width: 10),
                    TimePicker(
                      selectedTime: _selectedTime,
                      onPickTime: _pickTime,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ImagePickerWidget(
                      onPickImage: _pickImage,
                    ),
                    const SizedBox(width: 10),
                    SelectedImagesWidget(selectedImages: _selectedImages),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: _descriptionController),
                const SizedBox(height: 5),
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
                          _enteredAddress = null;
                          _descriptionController.clear();
                        });
                      },
                      child: const Row(
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
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.phone,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CustomIconButton(
                      icon: Icons.chat,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CustomIconButton(
                      icon: Icons.bookmark_added_sharp,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  PrimaryOutlinedButton(
                      text: "Cancel",
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(width: 10),
                  PrimaryFilledButton(
                      text: "Reserve",
                      onPressed: showReservationConfirmationDialog),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

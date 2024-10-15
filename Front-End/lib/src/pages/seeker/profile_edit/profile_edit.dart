import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationPreferencesController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _serviceCategory = 'Category 1'; // Ensure this matches one of the dropdown items
  String _languagePreference = 'English';
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  static const Color goldColor = Color(0xFFFFD700);
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = 'Nimal Perera';
    _phoneController.text = '0712345678';
    _emailController.text = 'nimal.perera@example.lk';
    _addressController.text = '123 Galle Road, Colombo, Sri Lanka';
    _bioController.text = 'Experienced professional in the service industry in Sri Lanka.';
    _locationPreferencesController.text = 'Colombo, Sri Lanka';
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _locationPreferencesController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission logic here
      // For example, send data to a server or update the UI
      print('Full Name: ${_fullNameController.text}');
      print('Phone Number: ${_phoneController.text}');
      print('Email Address: ${_emailController.text}');
      print('Address: ${_addressController.text}');
      print('Service Category: $_serviceCategory');
      print('Bio/Description: ${_bioController.text}');
      print('Location Preferences: ${_locationPreferencesController.text}');
      print('Email Notifications: $_emailNotifications');
      print('Push Notifications: $_pushNotifications');
      print('Language Preferences: $_languagePreference');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!)) as ImageProvider<Object>?
                      : const AssetImage('assets/fallback.jpg') as ImageProvider<Object>?,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.camera_alt,
                      color: goldColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
             
              const SizedBox(height: 20),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio/Description',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationPreferencesController,
                decoration: InputDecoration(
                  labelText: 'Location Preferences',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text('Email Notifications', style: TextStyle(color: goldColor)),
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Push Notifications', style: TextStyle(color: goldColor)),
                value: _pushNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _languagePreference,
                decoration: InputDecoration(
                  labelText: 'Language Preferences',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                items: <String>['English', 'Sinhala', 'Tamil']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _languagePreference = newValue!;
                  });
                },
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password Update',
                  labelStyle: TextStyle(color: goldColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: goldColor),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/pages/provider/components/custom_text_field.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/constants_color.dart';
import '../../provider/components/short_custom_text.dart';
import 'package:seyoni/src/config/url.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ProfileEditPageState createState() => ProfileEditPageState();
}

class ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // get the user details from shared preferences including the id
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _profileImage = prefs.getString('profileImageUrl');
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImageUrl', image.path);
      await prefs.setString('address', _addressController.text);
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? seekerId = prefs.getString('seekerId');

      if (seekerId == null || seekerId.isEmpty) {
        // Handle error
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/api/seeker/update'),
      );

      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['seekerId'] = seekerId;
      request.fields['firstName'] = _firstNameController.text;
      request.fields['lastName'] = _lastNameController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['email'] = _emailController.text;
      request.fields['address'] = _addressController.text;
      request.fields['password'] = _passwordController.text;

      if (_profileImage != null) {
        if (_profileImage!.startsWith('http')) {
          // Handle network image
          request.fields['profileImageUrl'] = _profileImage!;
        } else {
          // Handle local file
          var mimeTypeData =
              lookupMimeType(_profileImage!, headerBytes: [0xFF, 0xD8])
                  ?.split('/');
          var file = await http.MultipartFile.fromPath(
            'profileImage',
            _profileImage!,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
          );
          request.files.add(file);
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await prefs.setString('profileImageUrl', _profileImage ?? '');
        await prefs.setString('address', _addressController.text);
        await prefs.setString('firstName', _firstNameController.text);
        await prefs.setString('lastName', _lastNameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('phone', _phoneController.text);
        await prefs.setString('address', _addressController.text);

        // Clear the password field
        _passwordController.clear();

        // Show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: kPrimaryColor,
          ),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save changes. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: kSubtitleTextStyle),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      body: BackgroundWidget(
        child: SingleChildScrollView(
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
                        ? (_profileImage!.startsWith('http')
                            ? NetworkImage(_profileImage!)
                            : FileImage(File(_profileImage!))) as ImageProvider?
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShortCustomTextField(
                      controller: _firstNameController,
                      labelText: 'First Name',
                    ),
                    ShortCustomTextField(
                      controller: _lastNameController,
                      labelText: 'Last Name',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _addressController,
                  labelText: 'Address',
                ),
                const SizedBox(height: 26),
                // add a cuation message for confirm the details and enter password to save the changes
                Text(
                  'Please confirm the details and enter your password to save the changes.',
                  style: kBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                PrimaryFilledButton(
                  text: 'Save',
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

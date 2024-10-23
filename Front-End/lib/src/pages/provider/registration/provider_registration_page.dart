import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/config/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url.dart';
import '../../../constants/constants_font.dart';
import '../../../utils/validators.dart';
import '../../seeker/category/components/categories.dart';
import '../../seeker/category/components/subcategories.dart';
import '../../seeker/sign-pages/components/constants.dart';
import '../components/custom_text_field.dart';
import '../components/location_field.dart';
import '../components/short_custom_text.dart';
import 'package:http/http.dart' as http;

class ProviderRegistrationPage extends StatefulWidget {
  const ProviderRegistrationPage({super.key});

  @override
  ProviderRegistrationPageState createState() =>
      ProviderRegistrationPageState();
}

class ProviderRegistrationPageState extends State<ProviderRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  int _currentStep = 0;
  String? _selectedCategory;
  List<String> _selectedSubCategories = [];
  String? _selectedSubCategoryValue;
  XFile? _profileImage;
  XFile? _nicImageFront;
  XFile? _nicImageBack;

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  void _nextStep() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      if (_currentStep == 0) {
        // Send OTP
        final response = await http.post(
          Uri.parse(registerProvidersUrl_1),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': _emailController.text,
            'phone': _phoneController.text,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _currentStep++;
          });
        } else {
          // Handle error
        }
      } else if (_currentStep == 1) {
        // Verify OTP
        final response = await http.post(
          Uri.parse(registerProvidersUrl_2),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone': _phoneController.text,
            'otp': _otpController.text,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _currentStep++;
          });
        } else {
          // Handle error
        }
      } else if (_currentStep == 2) {
        // Upload profile image
        if (_profileImage != null) {
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(registerProvidersUrl_3),
          );
          request.fields['phone'] = _phoneController.text;
          request.files.add(await http.MultipartFile.fromPath(
              'profileImage', _profileImage!.path));

          final response = await request.send();
          if (response.statusCode == 200) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Handle error
          }
        }
      } else if (_currentStep == 3) {
        // Upload Front NIC images
        if (_nicImageFront != null) {
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(registerProvidersUrl_41),
          );
          request.fields['phone'] = _phoneController.text;
          request.files.add(await http.MultipartFile.fromPath(
              'nicFront', _nicImageFront!.path));

          final response = await request.send();
          if (response.statusCode == 200) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Handle error
          }
        }
      } else if (_currentStep == 4) {
        // Upload Back NIC image
        if (_nicImageBack != null) {
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(registerProvidersUrl_42),
          );
          request.fields['phone'] = _phoneController.text;
          request.files.add(await http.MultipartFile.fromPath(
              'nicBack', _nicImageBack!.path));

          final response = await request.send();
          if (response.statusCode == 200) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Handle error
          }
        }
      } else if (_currentStep == 5) {
        // Set password and complete registration
        final response = await http.post(
          Uri.parse(registerProvidersUrl_5),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone': _phoneController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'location': _locationController.text,
            'category': _selectedCategory,
            'subCategories': _selectedSubCategories,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final data = responseData['data'];
          final token = data['token'];
          final providerId = data['providerId'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('providerId', providerId);
          await prefs.setString('token', token);

          Navigator.pushNamed(context, AppRoutes.providerHomePage);
        } else {
          final error = jsonDecode(response.body)['error'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register: $error')),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(String imageType) async {
    try {
      ImageSource source = ImageSource.camera;
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Fallback to gallery on unsupported platforms
        source = ImageSource.gallery;
      }

      final XFile? image = await _picker.pickImage(source: source);
      setState(() {
        if (imageType == 'profile') {
          _profileImage = image;
        } else if (imageType == 'nicFront') {
          _nicImageFront = image;
        } else if (imageType == 'nicBack') {
          _nicImageBack = image;
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kTransparentColor,
          body: BackgroundWidget(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo-icon.png',
                    height: height * 0.15,
                    fit: BoxFit.contain,
                  ),
                  Image.asset(
                    'assets/images/logo-name.png',
                    height: height * 0.12,
                    fit: BoxFit.contain,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (_currentStep == 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShortCustomTextField(
                                  controller: _firstNameController,
                                  labelText: 'First Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                ),
                                ShortCustomTextField(
                                  controller: _lastNameController,
                                  labelText: 'Last Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _phoneController,
                              labelText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              validator: Validators.validatePhoneNumber,
                            ),
                            const SizedBox(height: 10),
                            LocationField(
                              controller: _locationController,
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  _locationController.text = suggestion;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.black.withOpacity(0.9),
                              decoration: InputDecoration(
                                labelStyle: kBodyTextStyle,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                labelText: 'Select Category',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                              ),
                              style: kTextFieldStyle,
                              items: categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['name'],
                                  child: Text(category['name']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                  _selectedSubCategories = [];
                                  _selectedSubCategoryValue = null;
                                  _formKey.currentState!.validate();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.black.withOpacity(0.9),
                              decoration: InputDecoration(
                                labelStyle: kBodyTextStyle,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                labelText: 'Select Sub Categories',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                              ),
                              style: kTextFieldStyle,
                              value:
                                  _selectedSubCategoryValue, // Reset the value to null
                              items: _selectedCategory == null
                                  ? []
                                  : subCategories[_selectedCategory]!
                                      .map((subCategory) {
                                      return DropdownMenuItem<String>(
                                        value: subCategory,
                                        child: Text(subCategory),
                                      );
                                    }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null &&
                                      !_selectedSubCategories.contains(value)) {
                                    _selectedSubCategories
                                        .add(value); // Add subcategory
                                    _selectedSubCategoryValue = value;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children:
                                  _selectedSubCategories.map((subCategory) {
                                return Chip(
                                  backgroundColor: kPrimaryColor,
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  label: Text(subCategory),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedSubCategories
                                          .remove(subCategory);
                                      if (_selectedSubCategories.isEmpty) {
                                        _selectedSubCategoryValue = null;
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryOutlinedButton(
                                  text: "Back",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(width: 10),
                                PrimaryFilledButton(
                                  text: 'Next',
                                  onPressed: _nextStep,
                                ),
                              ],
                            ),
                          ] else if (_currentStep == 1) ...[
                            CustomTextField(
                              controller: _otpController,
                              labelText: 'Enter OTP',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the OTP';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryOutlinedButton(
                                    text: "Back",
                                    onPressed: () {
                                      setState(() {
                                        _currentStep--;
                                      });
                                    }),
                                const SizedBox(width: 10),
                                PrimaryFilledButton(
                                  text: 'Verify OTP',
                                  onPressed: _nextStep,
                                ),
                              ],
                            ),
                          ] else if (_currentStep == 2) ...[
                            // Selfie Capture Step
                            const Text(
                              'Capture a Real-time Selfie',
                              style: kSubtitleTextStyle,
                            ),
                            const SizedBox(height: 10),
                            _profileImage == null
                                ? IconButton(
                                    icon: const Icon(Icons.person_add_alt_1,
                                        size: 100),
                                    onPressed: () => _pickImage('profile'),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 100,
                                    backgroundImage:
                                        FileImage(File(_profileImage!.path)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryFilledButtonTwo(
                                  text:
                                      _profileImage == null ? 'Take' : 'Retake',
                                  onPressed: () => _pickImage('profile'),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrimaryOutlinedButton(
                                      text: 'Back',
                                      onPressed: () {
                                        setState(() {
                                          _currentStep--;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    PrimaryFilledButton(
                                      text: 'Next',
                                      onPressed: _nextStep,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ] else if (_currentStep == 3) ...[
                            // NIC/Driving License Capture Step
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                textAlign: TextAlign.center,
                                'Capture NIC/Driving License FrontSide',
                                style: kSubtitleTextStyle,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _nicImageFront == null
                                ? IconButton(
                                    icon: const Icon(Icons.add_a_photo,
                                        size: 100),
                                    onPressed: () => _pickImage('nicFront'),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_nicImageFront!.path),
                                      width: 240,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryFilledButtonTwo(
                                  text: _nicImageFront == null
                                      ? 'Take'
                                      : 'Retake',
                                  onPressed: () => _pickImage('nicFront'),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrimaryOutlinedButton(
                                      text: 'Back',
                                      onPressed: () {
                                        setState(() {
                                          _currentStep--;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    PrimaryFilledButton(
                                      text: 'Next',
                                      onPressed: _nextStep,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ] else if (_currentStep == 4) ...[
                            // NIC/Driving License Capture Step
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                textAlign: TextAlign.center,
                                'Capture NIC/Driving License BackSide',
                                style: kSubtitleTextStyle,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _nicImageBack == null
                                ? IconButton(
                                    icon: const Icon(Icons.add_a_photo,
                                        size: 100),
                                    onPressed: () => _pickImage('nicBack'),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_nicImageBack!.path),
                                      width: 240,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryFilledButtonTwo(
                                  text:
                                      _nicImageBack == null ? 'Take' : 'Retake',
                                  onPressed: () => _pickImage('nicBack'),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PrimaryOutlinedButton(
                                      text: 'Back',
                                      onPressed: () {
                                        setState(() {
                                          _currentStep--;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    PrimaryFilledButton(
                                      text: 'Next',
                                      onPressed: _nextStep,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ] else if (_currentStep == 5) ...[
                            CustomTextField(
                              controller: _passwordController,
                              labelText: 'New Password',
                              obscureText: true,
                              validator: Validators.validatePassword,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: 'Confirm Password',
                              obscureText: true,
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                      value, _passwordController.text),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryOutlinedButton(
                                    text: "Back",
                                    onPressed: () {
                                      setState(() {
                                        _currentStep--;
                                      });
                                    }),
                                const SizedBox(width: 10),
                                PrimaryFilledButton(
                                    text: 'Register',
                                    onPressed: () {
                                      _nextStep();
                                    }),
                              ],
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: kParagraphTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.providerSignIn);
                                },
                                child: const Text('Sign In',
                                    style: TextStyle(color: kPrimaryColor)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Register as a service seeker',
                                style: TextStyle(
                                  color: kParagraphTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.signUp);
                                },
                                child: const Text('Register Now',
                                    style: TextStyle(color: kPrimaryColor)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
          ),
      ],
    );
  }
}

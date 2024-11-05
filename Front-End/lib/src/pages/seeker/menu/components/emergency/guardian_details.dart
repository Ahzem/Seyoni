import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../provider/components/custom_text_field.dart';
class GuardianDetailsPage extends StatefulWidget {
  const GuardianDetailsPage({super.key});

  @override
  _GuardianDetailsPageState createState() => _GuardianDetailsPageState();
}

class _GuardianDetailsPageState extends State<GuardianDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Variables to store guardian details
  String? guardianName;
  String? guardianPhone;
  String? guardianRelationship;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white, 
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Guardian Details',
            style: kTitleTextStyle,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display existing guardian details if available
              if (guardianName != null &&
                  guardianPhone != null &&
                  guardianRelationship != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      guardianName!,
                      style: kSubtitleTextStyle,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: $guardianPhone'),
                        Text('Relationship: $guardianRelationship'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Fill controllers with current details to edit
                        nameController.text = guardianName!;
                        phoneController.text = guardianPhone!;
                        relationshipController.text = guardianRelationship!;
                        // Rebuild to show the form
                        setState(() {});
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Show the form if details are being edited or adding new details
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Guardian Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the guardian\'s name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: phoneController,
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the phone number';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: relationshipController,
                      labelText: 'Relationship',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the relationship';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryOutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                        ),
                        const SizedBox(width: 20), // Increase space between buttons
                        PrimaryFilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // Save the input values to display as stored details
                              setState(() {
                                guardianName = nameController.text;
                                guardianPhone = phoneController.text;
                                guardianRelationship = relationshipController.text;
                              });
                              // Optionally, clear the form or close it
                              nameController.clear();
                              phoneController.clear();
                              relationshipController.clear();
                              Navigator.pop(context);
                            }
                          },
                          text: 'Save',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

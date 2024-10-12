import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../constants.dart';
import '../../../../../constants/constants_color.dart';
import '../../../../../constants/constants_font.dart';

const double height = 10;
const double width = 30.0;

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const PhoneNumberField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  PhoneNumberFieldState createState() => PhoneNumberFieldState();
}

class PhoneNumberFieldState extends State<PhoneNumberField> {
  Country selectedCountry = Country(
    phoneCode: '94',
    countryCode: 'LK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Sri Lanka',
    example: '712345678',
    displayName: 'Sri Lanka (ශ්‍රී ලංකා)',
    displayNameNoCountryCode: 'LK',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: kTextFieldStyle,
      decoration: InputDecoration(
        filled: false,
        fillColor: kContainerColor,
        errorMaxLines: 3,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kErrorColor),
        ),
        labelText: 'Enter your phone number',
        labelStyle: kBodyTextStyle,
        contentPadding: const EdgeInsets.symmetric(
          vertical: height,
          horizontal: width,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              showCountryPicker(
                countryListTheme: const CountryListThemeData(
                  bottomSheetHeight: 500,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  flagSize: 26,
                  searchTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  inputDecoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  // blured background for bottom sheet
                  backgroundColor: kPrimaryColor,
                ),
                context: context,
                onSelect: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              );
            },
            child: Text(
                '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kBoarderColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kBoarderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.errorText;
        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Invalid phone number';
        }
        return null;
      },
    );
  }
}

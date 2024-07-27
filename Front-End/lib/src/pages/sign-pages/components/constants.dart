import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

// Text field constants for sign in and sign up pages
const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kContainerColor,
  hintText: 'Enter your email',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kBoarderColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kBoarderColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
);

const kPasswordFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kContainerColor,
  hintText: 'Enter your password',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kBoarderColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kBoarderColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
);

const kTextFieldStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const kTextFieldLabelStyle = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const kTextFieldErrorStyle = TextStyle(
  color: kPrimaryColor,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

const kTextFieldErrorDecoration = InputDecoration(
  filled: true,
  fillColor: kContainerColor,
  hintText: 'Enter your email',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
);

const kPasswordFieldErrorDecoration = InputDecoration(
  filled: true,
  fillColor: kContainerColor,
  hintText: 'Enter your password',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kPrimaryColor),
  ),
);

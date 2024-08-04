import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

const double height = 10;
const double width = 30.0;

const kTextFieldDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Enter your email',
  hintStyle: kBodyTextStyle,
  prefixIcon: Icon(
    size: 25,
    Icons.email_sharp,
    color: kPrimaryColor,
  ),
  prefixIconConstraints: BoxConstraints(minWidth: 50),
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width,
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

const kTextFieldErrorDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Enter your email',
  hintStyle: kBodyTextStyle,
  prefixIcon: Icon(
    size: 25,
    Icons.email_sharp,
    color: kErrorColor,
  ),
  prefixIconConstraints: BoxConstraints(minWidth: 50),
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kErrorColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kErrorColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kErrorColor),
  ),
);

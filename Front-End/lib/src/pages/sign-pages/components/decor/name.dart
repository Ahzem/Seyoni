import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

const double height = 10;
const double width = 30.0;

const kFNameFieldDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'First Name',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width / 2,
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

const kFNameFieldErrorDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'First Name',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width / 2,
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

const kLNameFieldDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Last Name',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width / 2,
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

const kLNameFieldErrorDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Last Name',
  hintStyle: kBodyTextStyle,
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width / 2,
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

import 'package:flutter/material.dart';
import '../../../../../constants/constants_color.dart';
import '../../../../../constants/constants_font.dart';

const double height = 10;
const double width = 30.0;

const kPasswordFieldDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  errorMaxLines: 3,
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
    borderSide: BorderSide(color: kErrorColor),
  ),
  hintText: 'Enter your password',
  hintStyle: kBodyTextStyle,
  prefixIcon: Icon(
    size: 25,
    Icons.lock_outline_rounded,
    color: kPrimaryColor,
  ),
  prefixIconConstraints: BoxConstraints(minWidth: 50),
  suffixIcon: Icon(
    key: Key('password_visibility'),
    size: 20,
    Icons.visibility_off,
    color: kParagraphTextColor,
  ),
  suffixIconConstraints: BoxConstraints(minWidth: 50),
  contentPadding: EdgeInsets.symmetric(
    vertical: height,
    horizontal: width,
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

import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';

const double height = 10;
const double width = 30.0;

const kReferralFieldDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Refreall Code',
  hintStyle: kBodyTextStyle,
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

const kReferralFieldErrorDecoration = InputDecoration(
  filled: false,
  fillColor: kContainerColor,
  hintText: 'Referral Code',
  hintStyle: kBodyTextStyle,
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

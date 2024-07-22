// Constants for the application
import 'package:flutter/material.dart';

// Theme colors
const kPrimaryColor = Color.fromRGBO(255, 165, 0, 1);
const kSecondaryColor = Color.fromRGBO(255, 165, 0, 0.5);
const kAccentColor = Color.fromRGBO(255, 165, 0, 0.2);
const kBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
const kParagraphTextColor = Color.fromRGBO(255, 255, 255, 0.8);
const kContainerColor = Color.fromRGBO(0, 0, 0, 0.5);
const kTransparentColor = Color.fromRGBO(0, 0, 0, 0);

// box border
const kBoarderColor = Color.fromRGBO(255, 165, 0, 50);

const kDefaultPadding = 20.0;
const kDefaultBorderRadius = 20.0;
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12,
);

// font constants
const kHeadingTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: kParagraphTextColor,
);

const kSubheadingTextStyle = TextStyle(
  fontSize: 24,
  color: kParagraphTextColor,
);

const kTitleTextStyle = TextStyle(
  fontSize: 18,
  color: kParagraphTextColor,
);

const kBodyTextStyle = TextStyle(
  fontSize: 14,
  color: kParagraphTextColor,
);

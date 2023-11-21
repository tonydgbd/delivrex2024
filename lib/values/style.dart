
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../values/colors.dart';
import '../values/dimens.dart';

final appBarStyle = GoogleFonts.quicksand(
  color: primaryColor,
  fontSize: textSizeLarge,
  fontWeight: FontWeight.bold,
);

final hintTextStyle = GoogleFonts.quicksand(
  color: Colors.grey.withOpacity(0.9),
  fontSize: textSizeSMedium,
  fontWeight: FontWeight.normal,
);

final errorTextStyle = GoogleFonts.roboto(
  color: Colors.red,
  fontSize: textSizeSmall,
  fontWeight: FontWeight.normal,
);

//Font Size Small and Color White
final smallNormalTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeSMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3);
final smallMediumTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeSMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3);
final smallBoldTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeSMedium,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3);

//Font Size Normal and Color White
final normalTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3);
final mediumTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3);
final boldTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeMedium,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3);

//Font Size Large and Color White
final normalLargeTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeLargeMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3);
final mediumLargeTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeLargeMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3);
    final mediumLargeTextStyle2 = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeLarge,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3);
    final mediumLargeTextStylewhite = GoogleFonts.quicksand(
    color: Colors.white,
    fontSize: textSizeLargeMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3);
final boldLargeTextStyle = GoogleFonts.quicksand(
    color: primaryTextColor,
    fontSize: textSizeLargeMedium,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3);

final semiSubTitleTextStyle = GoogleFonts.quicksand(
    fontSize: textSizeSMedium,
    letterSpacing: 0.3,
    color: secondaryTextColor,
    fontWeight: FontWeight.w400); // Semi sub title with regular

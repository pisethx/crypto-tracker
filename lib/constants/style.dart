import 'package:flutter/material.dart';

// colors
final Color kPrimaryColor = Color(0xFF2B52DB);
final Color kLightGrayColor = Colors.grey[400];
final Color kGrayColor = Colors.grey[600];
final Color kDarkGrayColor = Colors.grey[800];
// final Color kIncomeColor = Color(0xFF2B52DB);
// final Color kExpenseColor = Color(0xFF32A0DF);
final Color kIncomeColor = Colors.greenAccent[400];
final Color kExpenseColor = Colors.redAccent;
final Color kScaffoldBackgroundColor = Color(0xFFF8FAFD);

const kScreenMargin = EdgeInsets.only(left: 20.0, right: 20.0);
const kScreenPaddingPx = 20.0;
const kScreenPadding = EdgeInsets.all(kScreenPaddingPx);

final List<BoxShadow> kBoxShadowSm = [
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 18,
    offset: Offset(0, 3),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 14,
    offset: Offset(0, 7),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 127),
    spreadRadius: 1,
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 1,
    offset: Offset(0, 1),
  ),
];

final List<BoxShadow> kBoxShadowLg = [
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 36,
    offset: Offset(0, 7),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 28,
    offset: Offset(0, 15),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 127),
    spreadRadius: 1,
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  BoxShadow(
    color: Color.fromARGB(7, 4, 9, 20),
    spreadRadius: 1,
    blurRadius: 2,
    offset: Offset(0, 2),
  ),
];

final InputDecoration kOutlinedTextFieldStyle = InputDecoration(
  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[400], width: 2.0),
  ),
);

final TextStyle kButtonTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0);
final TextStyle kPrimaryTextStyle = kButtonTextStyle.copyWith(color: kPrimaryColor);
final TextStyle kTitleTextStyle = TextStyle(color: kDarkGrayColor, fontSize: 24.0);
final TextStyle kSubtitleTextStyle = TextStyle(color: kDarkGrayColor, fontSize: 18.0, fontWeight: FontWeight.w600);
final TextStyle kContentTextStyle = TextStyle(color: kDarkGrayColor, fontSize: 16.0, fontWeight: FontWeight.w600);
final TextStyle kCaptionTextStyle = TextStyle(color: kGrayColor, fontSize: 14.0);
final TextStyle kSubtitleAmountStyle = TextStyle(color: kDarkGrayColor, fontSize: 20.0, fontWeight: FontWeight.bold);

final ButtonStyle elevatedButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)),
  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return kPrimaryColor;
  }),
  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return Colors.white;
  }),
);

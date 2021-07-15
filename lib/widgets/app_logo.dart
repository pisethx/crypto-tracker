import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        'Crypto Tracker',
        style: kPrimaryTextStyle.copyWith(fontSize: 24.0),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        )
      ],
    );
  }
}

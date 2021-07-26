import 'package:crypto_tracker/constants/style.dart';
import 'package:flutter/material.dart';

class PopBackButton extends StatefulWidget {
  // final Function onPressed;

  // const PopBackButton({
  //   @required this.onPressed,
  // });

  @override
  _PopBackButtonState createState() => _PopBackButtonState();
}

class _PopBackButtonState extends State<PopBackButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: kPrimaryColor,
          size: 30,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

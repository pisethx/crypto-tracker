import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final Function onPressed;

  const PrimaryButton({
    @required this.label,
    @required this.onPressed,
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: elevatedButtonStyle,
        child: Text(
          widget.label,
          style: kButtonTextStyle,
        ),
      ),
    );
  }
}

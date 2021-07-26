import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final Function onPressed;
  final Widget icon;
  final bool loading;

  const PrimaryButton({
    this.icon = const Icon(Icons.add),
    this.loading = false,
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
      child: ElevatedButton.icon(
        icon: widget.loading ? SizedBox() : widget.icon,
        onPressed: widget.onPressed,
        style: elevatedButtonStyle,
        label: widget.loading
            ? SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                height: 24.0,
                width: 24.0,
              )
            : Text(
                widget.label,
                style: kButtonTextStyle,
              ),
      ),
    );
  }
}

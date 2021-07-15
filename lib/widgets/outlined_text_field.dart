import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class OutlinedTextField extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final String labelText;
  final Widget prefixIcon;
  final String defaultText;
  final bool obscureText;
  final TextEditingController controller;
  final Function functionValidate;
  final String parametersValidate;
  final TextInputAction actionKeyboard;
  final Function onSubmitField;
  final Function onFieldTap;

  const OutlinedTextField(
      {@required this.hintText,
      @required this.labelText,
      this.textInputType,
      this.defaultText,
      this.obscureText = false,
      this.controller,
      this.functionValidate,
      this.parametersValidate,
      this.actionKeyboard = TextInputAction.next,
      this.onSubmitField,
      this.onFieldTap,
      this.prefixIcon});

  @override
  _OutlinedTextFieldState createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  FocusNode _focusNode = FocusNode();
  Color _labelColor;

  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(() {
      setState(() {
        _labelColor = _focusNode.hasFocus ? kPrimaryColor : kGrayColor;
      });
    });

    return Container(
      child: TextField(
        focusNode: _focusNode,
        decoration: kOutlinedTextFieldStyle.copyWith(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: _labelColor)),
      ),
    );
  }
}

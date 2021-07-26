import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:flutter/services.dart';

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
  final Function onChanged;
  final Function onFieldTap;
  final TextInputType keyboardType;
  final initialValue;

  const OutlinedTextField(
      {this.hintText,
      this.labelText,
      this.textInputType,
      this.defaultText,
      this.obscureText = false,
      this.controller,
      this.functionValidate,
      this.parametersValidate,
      this.actionKeyboard = TextInputAction.next,
      this.onChanged,
      this.onFieldTap,
      this.prefixIcon,
      this.keyboardType,
      this.initialValue});

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

    TextEditingController _controller = TextEditingController();
    _controller..text = widget.initialValue?.toString() ?? '';

    return Container(
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,
        inputFormatters:
            widget.keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))] : [],
        decoration: kOutlinedTextFieldStyle.copyWith(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: _labelColor)),
      ),
    );
  }
}

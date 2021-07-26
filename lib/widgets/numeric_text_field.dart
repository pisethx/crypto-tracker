import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/services.dart';

class NumericTextField extends StatefulWidget {
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
  final String suffixText;
  final double height;
  final Function onChanged;
  final initialValue;

  const NumericTextField(
      {this.hintText,
      this.labelText,
      this.textInputType,
      this.defaultText,
      this.obscureText = false,
      this.controller,
      this.functionValidate,
      this.parametersValidate,
      this.actionKeyboard = TextInputAction.next,
      this.onSubmitField,
      this.onFieldTap,
      this.prefixIcon,
      this.suffixText,
      this.height,
      this.onChanged,
      this.initialValue});

  @override
  _NumericTextFieldState createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextField(
      onChanged: widget.onChanged,
      controller: _controller,
      fullwidth: false,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      autofocus: true,
      minWidth: 250,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, color: kDarkGrayColor, fontSize: widget.height),
      decoration: InputDecoration(
        hintText: '0',
        suffix: Text(
          widget.suffixText,
          style: TextStyle(fontWeight: FontWeight.bold, color: kLightGrayColor, fontSize: widget.height / 2.5),
        ),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

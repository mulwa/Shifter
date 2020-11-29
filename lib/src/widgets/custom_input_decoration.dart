import 'package:flutter/material.dart';
import 'package:shifter_app/src/utils/constants.dart';

class CustomInputDecoration extends InputDecoration {
  final String labelText;
  final String hintText;

  CustomInputDecoration({this.hintText, this.labelText})
      : super(
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintColor,
            ),
            border: InputBorder.none,
            fillColor: inputBackground,
            filled: true);
}

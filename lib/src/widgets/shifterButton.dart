import 'package:flutter/material.dart';
import 'package:shifter_app/src/widgets/custom_button.dart';

class ShifterButton extends CustomRaisedButton {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  ShifterButton({this.onPressed, this.title, this.color: Colors.black})
      : super(
            child: Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            onPressed: onPressed,
            color: color);
}

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  CustomRaisedButton(
      {this.child, this.color: Colors.blueAccent, this.onPressed});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        color: color,
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}

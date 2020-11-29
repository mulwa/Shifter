import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final Color color;

  const AppCard({Key key, this.child, this.color= Colors.white}) : super(key: key);
  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
//          margin: EdgeInsets.all(0.0),
          color: widget.color,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: widget.child,
          ),
        )
      ],
    );
  }
}

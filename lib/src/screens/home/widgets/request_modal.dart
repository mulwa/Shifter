import 'package:flutter/material.dart';
import 'package:shifter_app/src/widgets/shifterButton.dart';

class RequestModal extends StatefulWidget {
  final double height;
  const RequestModal({
    Key key,
    this.height,
  }) : super(key: key);

  @override
  _RequestModalState createState() => _RequestModalState();
}

class _RequestModalState extends State<RequestModal>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
          height: widget.height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/tax.png',
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Taxi',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '20Km',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Text("Ksh 1,9000",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800))
                    ],
                  ),
                ),
              ),
              ShifterButton(
                title: "Request",
                onPressed: () {
                  print("Hello requesting");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

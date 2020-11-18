import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shifter_app/src/widgets/shifter_divider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 0;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.129154, 36.995559),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: Container(
            width: 250,
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Container(
                  height: 160,
                  child: DrawerHeader(
                      child: Row(
                    children: [
                      Image.asset(
                        'images',
                        height: 60.0,
                        width: 60.0,
                      )
                    ],
                  )),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(bottom: mapBottomPadding),
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {
                    mapBottomPadding = 290;
                  });
                },
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7)),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Nice to see you",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "Where are you going?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    offset: Offset(0.7, 0.7))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("Search Destination")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22.0,
                        ),
                        IconTitle(
                          icon: OMIcons.home,
                          title: "Add Home",
                          subTitle: "Your residential address",
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        ShiftDivider(),
                        SizedBox(
                          height: 16.0,
                        ),
                        IconTitle(
                          icon: OMIcons.workOutline,
                          title: "Add Work",
                          subTitle: "Your office address",
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class IconTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  const IconTitle({
    Key key,
    this.icon,
    this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.raleway(
                  fontSize: 16.0, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              subTitle,
              style: GoogleFonts.raleway(
                  textStyle: TextStyle(fontSize: 16.0, color: Colors.grey)),
            )
          ],
        )
      ],
    );
  }
}

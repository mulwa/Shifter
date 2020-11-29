import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shifter_app/src/models/direction_details.dart';
import 'package:shifter_app/src/providers/app_state.dart';
import 'package:shifter_app/src/screens/search_destination.dart';
import 'package:shifter_app/src/utils/helper_methods.dart';
import 'package:shifter_app/src/widgets/drawer.dart';
import 'package:shifter_app/src/widgets/shifterButton.dart';
import 'package:shifter_app/src/widgets/shifter_divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 0;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<LatLng> polylineCordinates = [];
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  Set<Circle> _circle = {};
  double _requestSheetHeight = 0;
  double _searchSheetHeight = 300;
  double _requestingSheetHeight = 0;

  Position currentPosition;

  DirectionDetails tripDirectionDetails;
  bool drawerCanOpen = true;

  void setUpPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    String address =
        await HelperMethods.findCordinateAddress(position, context);

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: currentLatLng, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.129154, 36.995559),
    zoom: 14.4746,
  );

  Future<void> getDirection() async {
    print("hello");

    var pickUp = Provider.of<AppState>(context, listen: false).pickupAddress;
    print("tett ${pickUp.latitude} ${pickUp.longitude}");
    var destination =
        Provider.of<AppState>(context, listen: false).destinationAddress;
    print("tett ${destination.latitude} ${destination.longitude}");
    var pickLatLng = LatLng(pickUp.latitude, pickUp.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    var details =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);
    print(details.encodedPoints);
    setState(() {
      tripDirectionDetails = details;
    });
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(details.encodedPoints);
    polylineCordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng points) {
        polylineCordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    _polyline.clear();
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('polyid'),
          color: Color.fromARGB(255, 95, 109, 237),
          points: polylineCordinates,
          jointType: JointType.round,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      _polyline.add(polyline);
    });
    // make polyline to fit into the map
    LatLngBounds bounds;
    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    Marker pickUpMarker = Marker(
        markerId: MarkerId('pickup'),
        position: pickLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow:
            InfoWindow(title: pickUp.placeName, snippet: "My Location"));

    Marker destinationMarker = Marker(
        markerId: MarkerId('destination'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: destination.placeName, snippet: "Destination"));

    setState(() {
      _markers.add(pickUpMarker);
      _markers.add(destinationMarker);
    });

    Circle pickUpCircle = Circle(
        circleId: CircleId('pickup'),
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 12,
        center: pickLatLng,
        fillColor: Colors.green);

    Circle destinationCircle = Circle(
        circleId: CircleId('destination'),
        strokeColor: Colors.cyanAccent,
        strokeWidth: 3,
        radius: 12,
        center: destinationLatLng,
        fillColor: Colors.amberAccent);

    setState(() {
      _circle.add(pickUpCircle);
      _circle.add(destinationCircle);
    });
  }

  void showRequestSheet() async {
    await getDirection();
    setState(() {
      _searchSheetHeight = 0;
      _requestSheetHeight = 200;
    });
  }

  resetApp() {
    setState(() {
      polylineCordinates.clear();
      _polyline.clear();
      _circle.clear();
      _markers.clear();
      drawerCanOpen = true;
      _requestSheetHeight = 0;
      _searchSheetHeight = 300;
      _requestingSheetHeight = 0;
      setUpPositionLocator();
    });
  }

  showRequestingRideSheet() {
    setState(() {
      _requestingSheetHeight = 200;
      _requestSheetHeight = 0;
      mapBottomPadding = 200;
      drawerCanOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldkey,
          drawer: ShifferDrawer(),
          body: Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(bottom: mapBottomPadding),
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                polylines: _polyline,
                markers: _markers,
                circles: _circle,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;
                  setState(() {
                    mapBottomPadding = 290;
                  });
                  setUpPositionLocator();
                },
              ),
              // MenuButton
              Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    if (drawerCanOpen) {
                      scaffoldkey.currentState.openDrawer();
                    } else {
                      resetApp();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        drawerCanOpen ? Icons.menu : Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
// searchSheet
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Container(
                    height: _searchSheetHeight,
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
                          GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchDestination()));
                              if (res == 'getDirection') {
                                // await getDirection();
                                showRequestSheet();
                                drawerCanOpen = false;
                              }
                            },
                            child: Container(
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
                ),
              ),
              // billing details
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    height: _requestSheetHeight,
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
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      (tripDirectionDetails != null)
                                          ? tripDirectionDetails.durationText
                                          : "",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                    (tripDirectionDetails != null)
                                        ? 'Kshs ${HelperMethods.fareEstimate(tripDirectionDetails)}'
                                        : "",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                              ],
                            ),
                          ),
                        ),
                        ShifterButton(
                          title: "Request",
                          onPressed: () {
                            showRequestingRideSheet();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // requesting ride
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  child: Container(
                    height: _requestingSheetHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextLiquidFill(
                              text: 'Requesting a Ride....',
                              waveColor: Colors.black,
                              boxBackgroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              boxHeight: 40.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.green,
                                )),
                            child: Icon(
                              Icons.close,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
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

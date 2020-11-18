import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shifter_app/src/models/address.dart';
import 'package:shifter_app/src/models/direction_details.dart';
import 'package:shifter_app/src/providers/app_state.dart';
import 'package:shifter_app/src/utils/constants.dart';
import 'package:shifter_app/src/utils/request_helper.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(
      Position position, BuildContext context) async {
    String placeAddress = "";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCrUAOBai695_T7qrXL75koHmIUqXXAR7I";
    var res = await RequestHelper.getRequest(url);
    print(res);
    if (res != 'failed') {
      placeAddress = res['results'][0]['formatted_address'];
      Address pickUpAddress = new Address();
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.placeName = placeAddress;
      Provider.of<AppState>(context, listen: false)
          .updatePickupAddress(pickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    print("here");
    print("Lat ${startPosition.longitude}");
    print("Long ${endPosition.longitude}");
    DirectionDetails directionDetails = new DirectionDetails();
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$MAPKEY';
    try {
      var res = await RequestHelper.getRequest(url);
      print(res);
      if (res == 'failed') {
        return null;
      }

      directionDetails.durationText =
          res['routes'][0]['legs'][0]['duration']['text'];
      directionDetails.durationValue =
          res['routes'][0]['legs'][0]['duration']['value'];
      directionDetails.distanceText =
          res['routes'][0]['legs'][0]['distance']['text'];
      directionDetails.distanceValue =
          res['routes'][0]['legs'][0]['distance']['value'];
      directionDetails.encodedPoints =
          res['routes'][0]['overview_polyline']['points'];
    } catch (e) {
      print(e);
      return null;
    }
    return directionDetails;
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shifter_app/src/models/address.dart';
import 'package:shifter_app/src/providers/app_state.dart';
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
      pickUpAddress.latitude = position.longitude;
      pickUpAddress.placeName = placeAddress;
      Provider.of<AppState>(context, listen: false)
          .updatePickupAddress(pickUpAddress);
    }
    return placeAddress;
  }
}

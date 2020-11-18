import 'package:flutter/material.dart';
import 'package:shifter_app/src/models/address.dart';

class AppState extends ChangeNotifier {
  Address pickupAddress;
  Address destinationAddress;

  void updatePickupAddress(Address pickup) {
    pickupAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address address) {
    destinationAddress = address;
    notifyListeners();
  }
}

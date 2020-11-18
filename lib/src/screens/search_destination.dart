import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:shifter_app/src/models/place_prediction.dart';
import 'package:shifter_app/src/providers/app_state.dart';
import 'package:shifter_app/src/utils/constants.dart';
import 'package:shifter_app/src/utils/request_helper.dart';
import 'package:shifter_app/src/widgets/prediction_tile.dart';

class SearchDestination extends StatefulWidget {
  @override
  _SearchDestinationState createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  FocusNode focusDestination = FocusNode();
  bool focused = false;

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPrediction = [];

  void searchPlace(String placeName) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$MAPKEY&sessiontoken=1234567890&components=country:ke";

    if (placeName.length > 2) {
      var res = await RequestHelper.getRequest(url);
      if (res == 'failed') {
        return;
      }
      if (res['status'] == 'OK') {
        var predictionJson = res['predictions'];

        var predictionList = (predictionJson as List)
            .map((e) => Prediction.fromJson(e))
            .toList();
        setState(() {
          destinationPrediction = predictionList;
        });
      }
      print(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    String address =
        Provider.of<AppState>(context).pickupAddress.placeName ?? "";
    pickUpController.text = address;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                          child: Text('Set Destination',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)))
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/pickIcon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickUpController,
                              decoration: InputDecoration(
                                  hintText: 'Pickup Location',
                                  fillColor: Colors.grey,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/pickIcon2.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (val) {
                                searchPlace(val);
                              },
                              focusNode: focusDestination,
                              controller: destinationController,
                              decoration: InputDecoration(
                                  hintText: 'Where to ?',
                                  fillColor: Colors.grey,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 8, bottom: 8),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          (destinationPrediction.length > 0)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PridictionTile(
                          prediction: destinationPrediction[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, index) {
                        return Divider();
                      },
                      itemCount: destinationPrediction.length),
                )
              : Container()
        ],
      ),
    );
  }
}

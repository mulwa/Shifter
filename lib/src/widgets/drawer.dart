import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shifter_app/src/styles/styles.dart';

class ShifferDrawer extends StatelessWidget {
  const ShifferDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Container(
            height: 160,
            color: Colors.white,
            child: DrawerHeader(
                child: Row(
              children: [
                Image.asset(
                  'assets/images/user_icon.png',
                  height: 60.0,
                  width: 60.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Christopher Mulwa",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("View Profile")
                  ],
                )
              ],
            )),
          ),
          // ShiftDivider()
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(OMIcons.cardGiftcard),
            title: Text(
              "Free Rides",
              style: kDrawerItemStyle,
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.creditCard),
            title: Text(
              "Payments",
              style: kDrawerItemStyle,
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.history),
            title: Text(
              "History",
              style: kDrawerItemStyle,
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.contactSupport),
            title: Text(
              "Support",
              style: kDrawerItemStyle,
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.info),
            title: Text(
              "About",
              style: kDrawerItemStyle,
            ),
          )
        ],
      ),
    );
  }
}

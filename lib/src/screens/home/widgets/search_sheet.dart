import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchSheet extends StatelessWidget {
  const SearchSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Positioned(
    //   right: 0,
    //   left: 0,
    //   bottom: 0,
    //   child: Container(
    //     height: 300.0,
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(15.0),
    //             topRight: Radius.circular(15.0)),
    //         boxShadow: [
    //           BoxShadow(
    //               color: Colors.black26,
    //               blurRadius: 15.0,
    //               spreadRadius: 0.5,
    //               offset: Offset(0.7, 0.7)),
    //         ]),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             height: 5,
    //           ),
    //           Text(
    //             "Nice to see you",
    //             style: TextStyle(fontSize: 10),
    //           ),
    //           Text(
    //             "Where are you going?",
    //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    //           ),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           GestureDetector(
    //             onTap: () async {
    //               var res = await Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => SearchDestination()));
    //               if (res == 'getDirection') {
    //                 await getDirection();
    //               }
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(4),
    //                   boxShadow: [
    //                     BoxShadow(
    //                         color: Colors.black12,
    //                         blurRadius: 5.0,
    //                         offset: Offset(0.7, 0.7))
    //                   ]),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(12.0),
    //                 child: Row(
    //                   children: [
    //                     Icon(
    //                       Icons.search,
    //                       color: Colors.blueAccent,
    //                     ),
    //                     SizedBox(
    //                       width: 10.0,
    //                     ),
    //                     Text("Search Destination")
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 22.0,
    //           ),
    //           IconTitle(
    //             icon: OMIcons.home,
    //             title: "Add Home",
    //             subTitle: "Your residential address",
    //           ),
    //           SizedBox(
    //             height: 16.0,
    //           ),
    //           ShiftDivider(),
    //           SizedBox(
    //             height: 16.0,
    //           ),
    //           IconTitle(
    //             icon: OMIcons.workOutline,
    //             title: "Add Work",
    //             subTitle: "Your office address",
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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

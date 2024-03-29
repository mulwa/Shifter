import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shifter_app/src/providers/app_state.dart';
import 'package:shifter_app/src/screens/authentication/loginPage.dart';
import 'package:shifter_app/src/screens/authentication/splash_screen.dart';
import 'package:shifter_app/src/screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        title: 'Shifter',
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/home": (BuildContext context) => HomePage(),
          "/login": (BuildContext context) => LoginPage()
        },
        home: SplashScreen(),
      ),
    );
  }
}

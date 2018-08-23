// # Parola
// ### An event based attendance using Beacon Technology

//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!
// UPDATE: I've organized my widgets to separate dart files
// so that you can find where and what is this
// doing. **OPEN THIS PROJECT IN AN EDITOR TO FIND THE PATH WHAT YOU ARE LOOKING FOR**.
// I did this because I want to make a rule **"100 lines of code per file"**.

import 'dart:async';

import 'package:final_parola/beacon/connectBeacon.dart';
import 'package:final_parola/home/home.dart';
import 'package:final_parola/home/introduction.dart';
import 'package:final_parola/home/scaffold.dart';
import 'package:final_parola/login/login.dart';
import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:final_parola/events/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery/battery.dart';

void main() {
  runApp(SplashScreen());
}

///This class will save the User's
///information to access the homepage
///

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return new SplashScreenState();
  }
}

///
///Checks if the `user` has signed in after closing
///the application
class SplashScreenState extends State<SplashScreen> {
  Battery battery = new Battery();
  int batteryLevel = 0;
  Color parolaColor = Colors.red[400];
  Color btnParola = Colors.red[200];
  Color cardColor = Colors.red[600];
  bool isLoggedIn = false;
  Future<bool> loggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        isLoggedIn = true;
        print(prefs.getString('username'));
      } else {
        isLoggedIn = false;
      }
    });

    return isLoggedIn;
  }

  Future<int> currentBattery() async {
    batteryLevel = await battery.batteryLevel;

    return batteryLevel;
  }

  @override
  void initState() {
    this.currentBattery();
    this.loggedIn();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(isLoggedIn: isLoggedIn, batteryLevel: batteryLevel),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
              title: TextStyle(color: Colors.white),
              display4: TextStyle(color: Colors.white)),
          errorColor: Colors.red[100],
          backgroundColor: Colors.red[400],
          buttonColor: btnParola,
          cardColor: cardColor,
          scaffoldBackgroundColor: parolaColor,
        ),
        title: 'Parola',
        // showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        home: ScopedModelDescendant<UserModel>(
            rebuildOnChange: false,
            builder: (context, child, model) {
              return isLoggedIn ? HomePage() : LoginPage();
            }),
        // initialRoute: "/login",
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/event': (context) => EventPage(),
          '/attend': (context) => BeaconConnect(),
          '/homePage': (context) => MyScaffold(),
          '/introduction': (context) => IntroductionPage(),
        },
      ),
    );
  }
}

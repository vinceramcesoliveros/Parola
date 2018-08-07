//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!
// UPDATE: I've organized my widgets to separate dart files 
// so that you can find where and what is this
// doing. OPEN THIS PROJECT IN AN EDITOR TO FIND THE PATH WHAT YOU ARE LOOKING FOR.
// I did this because I want to make a rule "100 lines of code per file".

import 'dart:async';
import 'dart:io';

import 'package:final_parola/home/home.dart';
import 'package:final_parola/login/login.dart';
import 'package:flutter/material.dart';
// import 'package:beacons/beacons.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_parola/events.dart';

void main() {
  runApp(SplashScreen());
}

bool loggedIn = false;

///This class will save the User's
///information to access the homepage
///

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  ///
  ///Checkes if the [user] has signed in after closing
  ///the application
  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("username") != null) {
      loggedIn = true;
      print(prefs.getString('username'));
    } else {
      loggedIn = false;
    }
    return loggedIn;
  }

  Color parolaColor = Colors.red[400];
  Color btnParola = Colors.red[200];
  Color cardColor = Colors.red[600];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: MaterialApp(
        // showPerformanceOverlay: true,
        // showPerformanceOverlay: true,
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
        home: loggedIn == true ? HomePage() : LoginPage(),
        // initialRoute: "/login",
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/event': (context) => EventPage(),
        },
      ),
    );
  }

  Future<bool> _onExit() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit Parola"),
              content: Text("Do you want to exit Parola?"),
              actions: <Widget>[
                RaisedButton(
                  child: Text(
                    "Nope",
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: Text(
                      "Yes",
                    ),
                    onPressed: () => exit(0)),
              ],
            ));
  }

  @override
  void initState() {
    this.setState(() {
      this._isLoggedIn();
    });

    super.initState();
  }
}

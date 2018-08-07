//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/profile.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = FirebaseApp.instance;
  final config = FirebaseApp.configure(
      name: 'Parola',
      options: FirebaseOptions(
          projectID: 'parola-2468e',
          googleAppID: '1:818472414092:android:a9c5fa1888c6f112',
          apiKey: 'AIzaSyC5oO96yzVWTdgDZWG44GZ7kATMq603tSA'));
  @override
  void initState() {
    _storeUser();
    super.initState();
  }

  _storeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final DocumentReference userRef = Firestore.instance
        .collection("users")
        .document(prefs.getString("userid"));
    Map<String, String> userData = {
      "username": prefs.getString("username") ?? '',
      "email": prefs.getString("useremail") ?? '',
      "photoURL": prefs.getString("userphotoURL") ?? '',
    };

    ///Equivalent to
    ///Insert into users values (userID,email,photoURL)
    /// FIXME: User gets to be inserted everytime he/she logs in.
    await userRef
        .setData(userData,
            merge: true) // Check if the userID has duplicate data
        .whenComplete(() => print("User added"))
        .catchError((e) => print(e));
  }

  // Widget currentPage;
  // int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: currentTab,
        //   items: <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home), title: Text("Home")),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.event), title: Text("Events")),
        //   ],
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(FontAwesomeIcons.bluetoothB),
          onPressed: () {},
          label: Text("Join Event"),
          backgroundColor: Colors.red[800],
        ),
        backgroundColor: Colors.red[400],
        appBar: AppBar(
          title: CircleAvatar(
              child: SvgPicture.asset(
                'assets/lighthouse.svg',
                height: 32.0,
                width: 32.0,
              ),
              maxRadius: 32.0,
              backgroundColor: Colors.red[400]),
          elevation: 0.0,
          backgroundColor: Colors.red[400],
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              splashColor: Colors.red[400],
              icon: Icon(
                Icons.add,
                size: 32.0,
              ),
              onPressed: () => Navigator.pushNamed(context, '/event'),
            )
          ],
        ),
        drawer: UserDrawer(),
        body: HomeBodyPage(),
      ),
    );
  }

  Future<bool> _onExit() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit Parola?"),
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
                      style: TextStyle(color: Colors.red[200]),
                    ),
                    onPressed: () => exit(0)),
              ],
            ));
  }
}

//Add Bottom Navigation

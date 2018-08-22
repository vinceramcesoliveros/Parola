//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/home/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _connectionStatus = 'Unknown';
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _storeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String useremail;
    final DocumentReference userRef = Firestore.instance
        .collection("users")
        .document(prefs.getString("userid"));
    Map<String, String> userData = {
      "username": prefs.getString("username") ?? '',
      "email": prefs.getString("useremail") ?? '',
      "photoURL": prefs.getString("userphotoURL") ?? '',
    };
    final Future<QuerySnapshot> query = Firestore.instance
        .collection("users")
        .where("username", isEqualTo: prefs.getString("username"))
        .limit(1)
        .getDocuments();
    query.then((doc) async {
      useremail = doc.documents[0].data['email'].toString();
      useremail!= prefs.getString("useremail")
          ? await userRef
              .setData(userData,
                  merge: true) // Check if the userID has duplicate data
              .whenComplete(() => print("User added"))
              .catchError((e) => print(e))
          : print("user is already added!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: MyScaffold(),
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

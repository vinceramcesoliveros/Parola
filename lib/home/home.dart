//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!

import 'dart:async';
import 'dart:io';
import 'package:final_parola/home/scaffold.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

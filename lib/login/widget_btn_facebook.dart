import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnFBSignIn extends StatelessWidget {
  @override
  Future<FirebaseUser> _facebookSignIn() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        textColor: Colors.white,
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.facebookF,
              size: 16.0,
            ),
            Text(" | ", style: TextStyle(fontSize: 16.0)),
            Text("Sign in with Facebook"),
          ],
        ),
        color: Colors.blue[700],
        onPressed: () {
          _facebookSignIn();
        });
  }
}
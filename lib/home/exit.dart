import 'dart:async';
import 'package:final_parola/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ExitParola extends StatefulWidget {
  @override
  _ExitParolaState createState() => _ExitParolaState();
}

class _ExitParolaState extends State<ExitParola> {
  Future<Null> _signOutGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _signIn = new GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _signIn.signOut();
    await _auth.signOut();
    prefs.clear();
    // prefs.commit();
    Navigator
        .of(context)
        .pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
    loggedIn = false;

    print(loggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Exit"),
      leading: Icon(Icons.exit_to_app),
      onTap: () => _signOutGoogle(),
    );
  }
}

import 'dart:async';
import 'package:final_parola/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnGoogleSignIn extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = new GoogleSignIn();

  ///Automatically Sign in from Splash Screen,
  ///[Google Sign in API]
  Future<FirebaseUser> googleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await _signIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();

    prefs.setString("username", user.displayName);
    prefs.setString("userid", user.uid);
    prefs.setString("useremail", user.email);
    prefs.setString("userphotoURL", user.photoUrl);
    loggedIn = true;

    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.red[500],
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.google, size: 16.0),
          Text(" | ", style: TextStyle(fontSize: 16.0)),
          Text("Sign in with Google"),
        ],
      ),
      onPressed: () async {
        await googleSignIn().then(
            (FirebaseUser user) => Navigator.of(context).pushNamed('/home'));
      },
    );
  }
}

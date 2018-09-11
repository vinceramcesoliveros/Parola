import 'dart:async';

import 'package:battery/battery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  UserModel({this.isLoggedIn, this.batteryLevel});
  bool isLoggedIn;
  bool get getlogin => isLoggedIn;

  Battery battery;
  int batteryLevel = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = new GoogleSignIn();

  final FacebookLogin facebookSignIn = new FacebookLogin();
  FirebaseUser user;

  ///Automatically Sign in from Splash Screen,
  Future<FirebaseUser> googleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await _signIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    try {
      user = await _auth
          .signInWithGoogle(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken)
          .catchError((e) {});
      assert(user.email != null);
      assert(user.displayName != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
  
      prefs.setString("username", user.displayName);
      prefs.setString("userid", user.uid);
      prefs.setString("useremail", user.email);
      prefs.setString("userphotoURL", user.photoUrl);
      isLoggedIn = true;
      return currentUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _signIn.signOut();
    await _auth.signOut();
    prefs.clear();
    // prefs.commit();
    isLoggedIn = false;
    return isLoggedIn;
  }

  Future<FirebaseUser> fbSignIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);
    FirebaseUser user =
        await _auth.signInWithFacebook(accessToken: result.accessToken.token);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();

    prefs.setString("username", user.displayName);
    prefs.setString("userid", user.uid);
    prefs.setString("useremail", user.email);
    prefs.setString("userphotoURL", user.photoUrl);
    isLoggedIn = true;
    return currentUser;
  }

  notifyListeners();
}

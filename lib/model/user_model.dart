import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  UserModel({this.isLoggedIn});
  bool isLoggedIn;
  bool get getlogin => isLoggedIn;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = new GoogleSignIn();

  ///Automatically Sign in from Splash Screen,
  /// # GOOGLE SIGN IN
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
    isLoggedIn = true;
    notifyListeners();
    return currentUser;
  }

  Future<bool> signOutGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _signIn = new GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _signIn.signOut();
    await _auth.signOut();
    prefs.clear();
    // prefs.commit();
    isLoggedIn = false;
    notifyListeners();
    return isLoggedIn;
  }
}

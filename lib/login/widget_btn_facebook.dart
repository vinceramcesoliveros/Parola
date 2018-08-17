import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class BtnFBSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        rebuildOnChange: false,
        builder: (context, child, model) => RaisedButton(
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
              onPressed: null,
              //  () async {
              //   await model.fbSignIn(context).then((FirebaseUser user) =>
              //       Navigator.of(context)
              //           .pushNamedAndRemoveUntil(
              //               '/introduction', ModalRoute.withName("/homePage"))
              //           .catchError((e) => showDialog(
              //               context: context,
              //               builder: (context) {
              //                 return AlertDialog(
              //                   title: Text("Sign in Error"),
              //                   actions: <Widget>[
              //                     FlatButton(
              //                       child: Text("OK"),
              //                       onPressed: () => Navigator.of(context).pop(),
              //                     )
              //                   ],
              //                 );
              //               })));
            ));
  }
}

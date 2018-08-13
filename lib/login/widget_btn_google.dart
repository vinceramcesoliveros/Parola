import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class BtnGoogleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) => RaisedButton(
            textColor: Colors.white,
            color: Colors.red[500],
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.google, size: 16.0),
                Text(" | ", style: TextStyle(fontSize: 16.0)),
                Text("Sign in to Google"),
              ],
            ),
            onPressed: () async {
              await model.googleSignIn().then((FirebaseUser user) =>
                  Navigator.of(context).pushNamed('/home'));
            },
          ),
    );
  }
}

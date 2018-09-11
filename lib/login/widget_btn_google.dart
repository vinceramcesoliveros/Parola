import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class BtnGoogleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      rebuildOnChange: false,
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
              await model
                  .googleSignIn()
                  .then((FirebaseUser user) => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              '/introduction', ModalRoute.withName("/homePage"))
                          .catchError((e) {
                        print(e);
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error!"),
                                content: Text(
                                    "Failed to sign in, Please Login again"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Ok")),
                                ],
                              );
                            });
                      }))
                  .catchError((e) {
                print(e);
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error!"),
                        content: Text("Failed to sign in, Please Login again"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Ok")),
                        ],
                      );
                    });
              });
            },
          ),
    );
  }
}

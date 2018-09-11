import 'package:final_parola/login/widget_btn_facebook.dart';
import 'package:final_parola/login/widget_btn_google.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: PBodyPage(),
    );
  }
}

class PBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Container(
        color: Colors.red[400],
        child: Column(
          children: <Widget>[
            ParolaIcon(),
            Text("Parola", style: Theme.of(context).textTheme.display4),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  BtnGoogleSignIn(),
                  BtnFBSignIn(),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}

class ParolaIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 32.0),
          child: CircleAvatar(
            backgroundColor: Colors.red[400],
            maxRadius: MediaQuery.of(context).size.shortestSide / 3,
            child: Image.asset('assets/lighthouse_app.png'),
          ),
        ),
      ],
    );
  }
}

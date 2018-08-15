import 'package:final_parola/login/widget_btn_facebook.dart';
import 'package:final_parola/login/widget_btn_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  static String lightHouse = 'assets/lighthouse.svg';
  static Widget svg = SvgPicture.asset(
    lightHouse,
    color: Colors.red[400],
    height: 128.0,
    width: 104.0,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 64.0),
          child: CircleAvatar(
            maxRadius: 64.0,
            backgroundColor: Colors.orange[200],
            child: svg,
          ),
        ),
      ],
    );
  }
}

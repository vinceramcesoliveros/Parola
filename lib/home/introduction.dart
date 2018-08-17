import 'dart:async';

import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';

import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:fancy_on_boarding/page_model.dart';
import 'package:battery/battery.dart';
import 'package:scoped_model/scoped_model.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  Battery _battery;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<UserModel>(
          rebuildOnChange: false,
          builder: (context, child, model) {
            TextStyle titleStyle = Theme.of(context).textTheme.display1;
            // TextStyle(  color: Colors.white, wordSpacing: 2.0, fontSize: 64.0);
            TextStyle bodyStyle = Theme.of(context).textTheme.display1;
            return FancyOnBoarding(pageList: [
              PageModel(
                  color: Colors.red[400],
                  iconAssetPath: 'assets/iconLighthouse.png',
                  heroAssetPath: 'assets/lighthouse.png',
                  title: Text(
                    "Welcome to Parola",
                    style: titleStyle,
                  ),
                  body: Text("Look at this fancy design by xsahil03x")),
              PageModel(
                color: model.batteryLevel >= 50
                    ? Colors.green[300]
                    : Colors.red[200],
                iconAssetPath: 'assets/icons8-empty-battery-50.png',
                heroAssetPath: model.batteryLevel >= 50
                    ? 'assets/battery_charge.png'
                    : 'assets/lowbat.png',
                title: Text(
                  "Battery Life",
                  style: titleStyle,
                ),
                body: model.batteryLevel >= 50
                    ? Text(
                        "Your battery Life is ${model.batteryLevel}%, Make sure to have plenty of energy left!",
                        style: bodyStyle,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        "Charge your phone before using it!",
                        style: bodyStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
              PageModel(
                  color: Colors.blue[200],
                  iconAssetPath: 'assets/icons8-bluetooth-24.png',
                  heroAssetPath: 'assets/bluetooth_icon.png',
                  title: Text(
                    "Bluetooth Low Energy",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  body: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Just turn on your bluetooth when you want to connect to the beacon you want to connect.",
                          style: bodyStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )),
            ], mainPageRoute: '/homePage');
          }),
    );
  }
}

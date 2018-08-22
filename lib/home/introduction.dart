import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
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
            List<PageViewModel> pageList = [
              PageViewModel(
                  iconImageAssetPath: 'assets/iconLighthouse.png',
                  pageColor: Colors.redAccent[200],
                  mainImage: Image.asset(
                    'assets/lighthouse.gif',
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.shortestSide,
                    width: MediaQuery.of(context).size.longestSide,
                  ),
                  title: Text(
                    "Welcome to Parola",
                    style: titleStyle,
                  ),
                  body: Text("Look at this fancy design by xsahil03x")),
              PageViewModel(
                pageColor: model.batteryLevel >= 50
                    ? Colors.green[300]
                    : Colors.red[200],
                iconImageAssetPath: 'assets/icons8-empty-battery-50.png',
                mainImage: model.batteryLevel >= 50
                    ? Image.asset('assets/battery_charge.png')
                    : Image.asset('assets/lowbat.png'),
                title: Text(
                  "Battery Life",
                  style: titleStyle,
                ),
                body: model.batteryLevel >= 50
                    ? Text(
                        "Your battery Life is ${model.batteryLevel}%, Make sure to have plenty of energy left!",
                      )
                    : Text(
                        "You have ${model.batteryLevel}%,Charge your phone before using it!",
                      ),
              ),
              PageViewModel(
                  pageColor: Colors.blue[200],
                  iconImageAssetPath: 'assets/icons8-bluetooth-24.png',
                  mainImage: Image.asset('assets/bluetooth_icon.png'),
                  title: Text(
                    "Bluetooth Low Energy",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  body: Text(
                    "Just turn on your bluetooth when you want to connect to the beacon you want to connect.",
                  )),
            ];
            return IntroViewsFlutter(
              pageList,
              onTapDoneButton: () {
                Navigator.of(context).pushReplacementNamed('/homePage');
              },
              onTapSkipButton: () {
                Navigator.of(context).pushReplacementNamed('/homePage');
              },
              showSkipButton: true,
            );
          }),
    );
  }
}

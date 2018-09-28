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
            TextStyle titleStyle = Theme.of(context).textTheme.title;
            List<PageViewModel> pageList = [
              PageViewModel(
                iconImageAssetPath: 'assets/lighthouse_app.png',
                pageColor: Colors.grey[400],
                mainImage: Image.asset(
                  'assets/lighthouse_app.png',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.shortestSide,
                  width: MediaQuery.of(context).size.longestSide,
                ),
                title: Text(
                  "Welcome to Parola",
                  style: titleStyle,
                ),
                body: Column(children: <Widget>[
                  Text(
                      'Hi ${model.user.displayName}! If it\'s not your real name, you can change it in the settings')
                ]),
              ),
              PageViewModel(
                  mainImage: Image.asset('assets/beacon_data.png'),
                  iconImageAssetPath: 'assets/beacon-example31.png',
                  pageColor: Colors.red[200],
                  title: Text("We don't steal information about you"),
                  body: Text(
                      "Beacons will not collect any information, they\'re just sending data to any near BLE devices")),
              PageViewModel(
                pageColor: model.batteryLevel >= 20
                    ? Colors.green[300]
                    : Colors.red[200],
                iconImageAssetPath: 'assets/icons8-empty-battery-50.png',
                mainImage: model.batteryLevel >= 20
                    ? Image.asset('assets/battery_charge.png')
                    : Image.asset('assets/lowbat.png'),
                title: Text(
                  "Battery Life",
                  style: titleStyle,
                ),
                body: model.batteryLevel >= 20
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
                  mainImage: Image.asset(
                    'assets/bluetooth_icon.png',
                    height: MediaQuery.of(context).size.shortestSide,
                    width: MediaQuery.of(context).size.longestSide,
                  ),
                  title: Text(
                    "Bluetooth Low Energy",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  body: Text("Your device must be compatible to Bluetooth LE")),
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

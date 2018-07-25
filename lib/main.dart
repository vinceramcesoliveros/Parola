import 'dart:async';

import 'package:flutter/material.dart';
import 'package:beacons/beacons.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(MyApp());
  StreamSubscription _scanSubscription;

  Beacons.loggingEnabled = true;
  Beacons.configure(BeaconsSettings(
      android: BeaconsSettingsAndroid(logs: BeaconsSettingsAndroidLogs.info),
      iOS: BeaconsSettingsIOS()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parola"),
      ),
      body: BodyPage(),
    );
  }
}

class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  Permission permission = Permission.AccessCoarseLocation;
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.bluetooth),
              Text("Turn Bluetooth on")
            ],
          ),
          onPressed: () {
            setState(() {
              _btOn();
            });
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  void _btOn() {
    showDialog(
        context: context,
        builder: ((context) => Column(
              children: <Widget>[
                Text(
                  "Turn Bluetooth on",
                  style: Theme.of(context).textTheme.display1,
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "CANCEL",
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                        child: Text(
                          "Turn on",
                        ),
                        onPressed: () {
                          FlutterBlue flutterBlue = FlutterBlue.instance;
                          final scanSubscription = flutterBlue
                              .scan(
                                  scanMode: ScanMode.balanced,
                                  timeout: Duration(milliseconds: 3000))
                              .listen((result) {
                            print("Bluetooth Start Scanning: $result");
                          }).onError((e) => print("Bluetooth Turned off"));
                        })
                  ],
                )
              ],
            )));
  }
}

class BeaconRanging extends Model {
  final beacon = Beacons
      .ranging(
        region: BeaconRegionIBeacon(
          identifier: "test",
          proximityUUID: "",
        ),
        permission: LocationPermission(
            android: LocationPermissionAndroid.coarse,
            ios: LocationPermissionIOS.whenInUse),
        inBackground: false,
      )
      .listen((result) {});
  void _startConnect() {
    beacon.cancel();
    notifyListeners();
  }
}

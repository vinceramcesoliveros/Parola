

//     return Column(
//       children: <Widget>[
//         FloatingActionButton(
//           elevation: 2.0,
//           child: Icon(Icons.bluetooth),
//           onPressed: () {
//             setState(() {
//               _btOn();
//             });
//           },
//         )
//       ],
//     );
//   }

//   _btOn() {
//      showDialog(
//        context: context,
//        builder: (context)=>
//        AlertDialog(
//       actions: <Widget>[],
//       title: Text("Bluetooth on"),
//       content: Column(
//         children: <Widget>[
//           Text(
//             "Turn Bluetooth on",
//             style: Theme.of(context).textTheme.display1,
//           ),
//           ButtonBar(
//             children: <Widget>[
//               FlatButton(
//                 child: Text(
//                   "CANCEL",
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               RaisedButton(
//                   child: Text(
//                     "Turn on",
//                   ),
//                   onPressed: () {
//                     _onStart();
//                   })
//             ],
//           )
//         ],
//       ),
//     ));

//   }

//   void _onStart() {
//     FlutterBlue flutterBlue = FlutterBlue.instance;
//     final scanSubscription = flutterBlue
//         .scan(
//             scanMode: ScanMode.balanced, timeout: Duration(milliseconds: 3000))
//         .listen((result) {
//       print("Bluetooth Start Scanning: $result");
//     });
//     scanSubscription.cancel();
//   }
// }

// class BeaconRanging extends Model {
//   final beacon = Beacons
//       .ranging(
//         region: BeaconRegionIBeacon(
//           identifier: "test",
//           proximityUUID: "",
//         ),
//         permission: LocationPermission(
//             android: LocationPermissionAndroid.coarse,
//             ios: LocationPermissionIOS.whenInUse),
//         inBackground: false,
//       )
//       .listen((result) {});
//   // void _startConnect() {
//   //   beacon.cancel();
//   //   notifyListeners();
//   // }
// }

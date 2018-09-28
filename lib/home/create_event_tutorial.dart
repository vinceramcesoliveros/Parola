import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class EventTutorial extends StatelessWidget {
  final List<PageViewModel> pageList = [
    PageViewModel(
      pageColor: Colors.blue[200],
      mainImage: Image.asset(
        'assets/beacon-example31.png',
        fit: BoxFit.fitWidth,
      ),
      iconImageAssetPath: 'assets/beacon-example31.png',
      title: Text("Step 1: Beacons"),
      body: Text("You must have a beacon to create an event"),
    ),
    PageViewModel(
        pageColor: Colors.green,
        mainImage: Image.asset('assets/beaconBrand.png'),
        iconImageAssetPath: 'assets/beacon-example31.png',
        title: Text("Step 2: Choose any Beacons"),
        body: Text("You can choose what type of beacons you want.")),
    PageViewModel(
        pageColor: Colors.orange[200],
        mainImage: Image.asset('assets/typeOfBeacon.png'),
        iconImageAssetPath: 'assets/beacon-example31.png',
        title: Text("Step 3: iBeacon & Eddystone Supported"),
        body: Text("Your beacon must have an iBeacon or Eddystone supported")),
    PageViewModel(
        pageColor: Colors.white70,
        mainImage: Image.asset('assets/beacon_mount.png'),
        iconImageAssetPath: 'assets/beacon-example31.png',
        title: Text("Step 4: Mount your Beacons"),
        body: Text("Mount your beacons where people can't reach it")),
    PageViewModel(
        pageColor: Colors.green[200],
        mainImage: Image.asset('assets/beacon_quantity.png'),
        iconImageAssetPath: 'assets/beacon-example31.png',
        title: Text("Step 5: Your beacon is set! 🎉"),
        body: Text("You can now create your own Event with beacons."))
  ];
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pageList,
      onTapDoneButton: () {
        Navigator.of(context).pushReplacementNamed('/event');
      },
      showSkipButton: false,
    );
  }
}

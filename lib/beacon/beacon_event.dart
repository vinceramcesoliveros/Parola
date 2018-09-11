import 'dart:async';
import 'dart:core';

import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/beacon/_header.dart';
import 'package:final_parola/beacon/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringTab extends ListTab {
  final String eventTitle, major, minor, beaconID;
  MonitoringTab({this.eventTitle, this.beaconID, this.major, this.minor})
      : super(title: eventTitle, beacon: beaconID, major: major, minor: minor);

  @override
  Stream<ListTabResult> stream(BeaconRegion region) {
    return Beacons.ranging(
      region: region,
      inBackground: false,
      permission: LocationPermission(android: LocationPermissionAndroid.coarse),
    ).map((result) {
      String text;
      if (result.isSuccessful == true) {
        text = result.beacons.isNotEmpty
            ? 'You are ${result.beacons.first.distance.toStringAsFixed(2)} meters from $eventTitle'
            : 'You are Disconnected from $eventTitle';
      } else {
        text = result.error.toString();
      }

      return new ListTabResult(
          text: text,
          isSuccessful: result.isSuccessful,
          description: "${result.beacons.first.distance.toStringAsFixed(2)}m");
    });
  }
}

abstract class ListTab extends StatefulWidget {
  const ListTab({Key key, this.title, this.beacon, this.major, this.minor})
      : super(key: key);
  final String title, beacon, major, minor;

  Stream<ListTabResult> stream(BeaconRegion region);

  @override
  _ListTabState createState() => new _ListTabState();
}

class _ListTabState extends State<ListTab> {
  List<ListTabResult> _results = [];
  StreamSubscription<ListTabResult> _subscription;
  bool _running = false;
  bool isConnected = false;

  Map<String, dynamic> attendees;
  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference attendeesRef =
        Firestore.instance.collection('AttendeesList').document(widget.title);

    void _onStart(BeaconRegion region) {
      Duration duration = Duration(seconds: 5);
      setState(() {
        _running = true;
      });

      _subscription = widget.stream(region).listen((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _results.clear();
          _results.insert(0, result);
          attendees = {
            "Names": {
              "userID": prefs.getString('userid'),
              "FullName": prefs.getString('username'),
              "status": {
                "Connected": result.isSuccessful,
                "Distance": result.description,
              }
            }
          };

          Future.delayed(duration, () async {
            Firestore.instance.runTransaction((transAttendees) async {
              DocumentSnapshot snapshot =
                  await transAttendees.get(attendeesRef);
              if (snapshot.exists) {
                transAttendees.update(attendeesRef, attendees);
              }
            });
            // attendeesRef
            //     .collection('Lists')
            //     .document(prefs.getString('userid'))
            //     .setData(attendees, merge: false);
          });
        });
      });

      _subscription.onDone(() {
        setState(() {
          _running = false;
        });
      });
    }

    void _onStop() {
      setState(() {
        _running = false;
        _results.clear();
        isConnected = false;
      });

      _subscription?.cancel();
    }

    return new Scaffold(
      backgroundColor:
          isConnected == true ? Colors.green[200] : Colors.red[200],
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor:
            isConnected == true ? Colors.green[200] : Colors.red[200],
        centerTitle: true,
        title: Header(
          regionIdentifier: 'test',
          running: _running,
          onStart: _onStart,
          onStop: _onStop,
          beaconID: widget.beacon,
          major: widget.major,
          minor: widget.minor,
        ),
      ),
      body: _running == true
          ? Stack(
              children: ListTile.divideTiles(
              context: context,
              tiles: _results.map((location) {
                isConnected = location.isSuccessful;

                return _Item(result: location);
              }),
            ).toList())
          : Center(child: Icon(Icons.signal_wifi_off, size: 64.0)),
    );
  }
}

class _Item extends StatelessWidget {
  _Item({@required this.result});

  final ListTabResult result;

  @override
  Widget build(BuildContext context) {
    final String text = result.text;
    final String status = result.isSuccessful ? "Connected" : "Not Connected";
    final List<Widget> content = <Widget>[
      Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
      Text(
        status,
        style: Theme.of(context).textTheme.caption,
      ),
      Icon(
        Icons.wifi,
        size: 64.0,
      )
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}

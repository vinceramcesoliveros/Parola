import 'dart:async';
import 'dart:core';

import 'package:beacons/beacons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/beacon/_header.dart';
import 'package:final_parola/beacon/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitoringTab extends ListTab {
  final String eventTitle, major, minor, beaconID, eventKey;
  final DateTime eventDateStart, eventTimeStart, eventTimeEnd;
  MonitoringTab(
      {this.eventTitle,
      this.beaconID,
      this.major,
      this.minor,
      this.eventKey,
      this.eventDateStart,
      this.eventTimeEnd,
      this.eventTimeStart})
      : super(
            title: eventTitle,
            beacon: beaconID,
            major: major,
            minor: minor,
            eventKey: eventKey,
            eventDate: eventDateStart,
            eventTimeStart: eventTimeStart,
            eventTimeEnd: eventTimeEnd);

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
            ? "You are ${result.beacons.first.distance < 5.0 ? 'Connected' : 'Too far'} from $eventTitle "
            : 'You are Disconnected from $eventTitle';
      } else {
        text = result.beacons.isNotEmpty == false
            ? result.error.toString()
            : "Unable To Connect";
      }

      return new ListTabResult(
          text: text,
          isSuccessful: result.beacons.first.distance < 5.0 ? true : false,
          distance: result.beacons.first.distance);
    });
  }
}

abstract class ListTab extends StatefulWidget {
  const ListTab(
      {Key key,
      this.title,
      this.beacon,
      this.major,
      this.minor,
      this.eventKey,
      this.eventDate,
      this.eventTimeEnd,
      this.eventTimeStart})
      : super(key: key);
  final String title, beacon, major, minor, eventKey;
  final DateTime eventDate, eventTimeStart, eventTimeEnd;

  Stream<ListTabResult> stream(BeaconRegion region);

  @override
  _ListTabState createState() => new _ListTabState();
}

class _ListTabState extends State<ListTab> {
  Map<String, dynamic> status = {
    "Connected": false,
    "Distance": "Disconnected",
  };
  Map<String, dynamic> outAttendance = new Map();
  Map<String, dynamic> setAttendees = {};
  List<ListTabResult> _results = [];
  StreamSubscription<ListTabResult> _subscription;
  bool _running = false;
  bool isConnected = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Map<String, dynamic> attendees;
  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("notification payload:" + payload);
    }
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future _showOngoingNotification({String successful, String status}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Min,
        priority: Priority.Low,
        ongoing: true,
        autoCancel: true,
        playSound: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, successful, status, platformChannelSpecifics);
  }

  Future _showStatusNotifcation({String successful, status}) async {
    await flutterLocalNotificationsPlugin.cancel(0);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Min,
      priority: Priority.Default,
      ongoing: true,
      autoCancel: true,
      playSound: false,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1, "Disconnected", "Beacon out of range", platformChannelSpecifics);
  }

  void _onStop() async {
    setState(() {
      _running = false;
      _results.clear();
      isConnected = false;
    });

    await _cancelNotification();
    _subscription?.cancel();
  }

  void _onStart(BeaconRegion region) {
    setState(() {
      _running = true;
    });
    _subscription = widget.stream(region).listen((result) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        if (result.text != null) {
          _results.clear();
          _results.insert(0, result);
        } else {
          _results.clear();
          _results.insert(
              0,
              ListTabResult(
                  text: "Failed to Connect",
                  isSuccessful: false,
                  distance: null));
          updateAttendees();
        }

        status = {
          "Connected": result.isSuccessful,
          "Distance": result.distance,
        };
        setAttendees = {
          "eventID": widget.eventKey,
          "eventName": widget.title,
          "userid": prefs.getString('userid'),
          "username": prefs.getString('username'),
          "status": status,
          "In": widget.eventTimeStart
                  .isAfter(widget.eventTimeStart.add(Duration(minutes: 15)))
              ? "Late"
              : "Attended",
        };
        outAttendance = {
          "eventID": widget.eventKey,
          "Out": DateTime.now().isAfter(widget.eventTimeEnd) &&
                  widget.eventTimeEnd
                      .isBefore(widget.eventTimeEnd.add(Duration(minutes: 10)))
              ? "Completed"
              : "Absent"
        };
        result.distance < 7.0
            ? _showOngoingNotification(
                successful:
                    result.distance < 7.0 ? 'Connected' : 'Disconnected',
                status: result.text)
            : _showStatusNotifcation();
      });
    });
    _subscription.onDone(() async {
      setState(() {
        _running = false;
      });
    });
  }

  void updateAttendees() async {
    Duration duration = Duration(seconds: 30);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentReference attendeesRef = Firestore.instance
        .document("${widget.eventKey}_attendees/${prefs.getString('userid')}");

    DocumentReference userRef = Firestore.instance.document(
        "event_attended_${prefs.getString('userid')}/${widget.eventKey}");

    if (widget.eventTimeStart
        .isBefore(widget.eventTimeStart.add(Duration(seconds: 10)))) {
      signInAttendees(
          duration: duration, attendees: attendeesRef, userRef: userRef);
    } else if (widget.eventTimeEnd
        .isAfter(widget.eventTimeEnd.add(Duration(minutes: 5)))) {
      signOutAttendees(
          duration: duration, attendees: attendeesRef, userRef: userRef);
    }
  }

  void signInAttendees(
      {@required Duration duration,
      @required DocumentReference attendees,
      @required DocumentReference userRef}) async {
    Future.delayed(duration, () async {
      Firestore.instance.runTransaction((transAttendees) async {
        DocumentSnapshot snapshot = await transAttendees.get(attendees);
        if (!snapshot.exists) {
          await transAttendees.set(attendees, setAttendees);
          Fluttertoast.showToast(
              msg: "You have been signed as ATTENDED",
              gravity: ToastGravity.BOTTOM);
        }
      });
    });
    Firestore.instance.runTransaction((tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        await tx.update(userRef, setAttendees);
      }
    });
  }

  void signOutAttendees(
      {@required Duration duration,
      @required DocumentReference attendees,
      @required DocumentReference userRef}) async {
    Future.delayed(duration, () async {
      Firestore.instance.runTransaction((transAttendees) async {
        DocumentSnapshot snapshot = await transAttendees.get(attendees);
        if (snapshot.exists) {
          await transAttendees.update(attendees, outAttendance);
          Navigator.of(context).pop();
          _onStop();
        }
      });
    });

    Firestore.instance.runTransaction((tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        await tx.update(userRef, outAttendance);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onStop();
        return true;
      },
      child: new Scaffold(
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
                children: _results.isNotEmpty
                    ? ListTile.divideTiles(
                        context: context,
                        tiles: _results.map((location) {
                          isConnected = location.isSuccessful;

                          return location.isSuccessful
                              ? _Item(result: location)
                              : Center(child: Text(location.text));
                        }),
                      ).toList()
                    : [
                        Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.signal_wifi_off,
                              size: 64.0,
                            ),
                            Text(
                              "Unable to connect, Maybe you're not at the event. 😞",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ],
                        ))
                      ])
            : Center(child: Icon(Icons.signal_wifi_off, size: 64.0)),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  _Item({@required this.result});

  final ListTabResult result;

  @override
  Widget build(BuildContext context) {
    final String text = result.text;
    final String status = result.isSuccessful
        ? "${result.distance.toStringAsFixed(2)}"
        : "Not Connected";
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

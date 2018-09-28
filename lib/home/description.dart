import 'dart:async';

import 'package:final_parola/beacon/beacon_event.dart';
import 'package:final_parola/beacon/beacon_event_out.dart';
import 'package:final_parola/events/edit_events.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DescPage extends StatefulWidget {
  final String eventTitle, username;

  DescPage({this.eventTitle, this.username});

  @override
  DescPageState createState() {
    return new DescPageState();
  }
}

class DescPageState extends State<DescPage> {
  Future<Null> startBluetooth() async {
    await FlutterScanBluetooth.startScan();
  }

  DateTime timeEnd, timeStart, eventDate;

  List<DocumentSnapshot> eventDesc = List();
  String description,
      eventName,
      eventLocation,
      major,
      minor,
      beaconUUID,
      eventKey;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final descQuery = Firestore.instance
        .collection('events')
        .where('eventName', isEqualTo: widget.eventTitle)
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          centerTitle: true,
          title: Text(widget.eventTitle),
          actions: <Widget>[
            StreamBuilder(
              stream: descQuery,
              builder: (context, snapshot) {
                eventDesc = snapshot.data.documents;
                description = eventDesc[0].data['eventDesc'].toString();
                eventName = eventDesc[0].data['eventName'].toString();

                eventLocation = eventDesc[0].data['eventLocation'].toString();

                timeEnd = eventDesc[0].data['timeEnd'];
                timeStart = eventDesc[0].data['timeStart'];
                eventDate = eventDesc[0].data['eventDate'];

                major = eventDesc[0].data['Major'].toString();

                minor = eventDesc[0].data['Minor'].toString();

                beaconUUID = eventDesc[0].data['beaconUUID'].toString();

                eventKey = eventDesc[0].documentID.toString();

                if (!snapshot.hasData) {
                  return Center(child: Text("Loading..."));
                } else {
                  return eventDesc[0].data['Admin'] == widget.username
                      ? IconButton(
                          icon: Icon(FontAwesomeIcons.solidEdit),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (eventDesc[0].data['Admin'] ==
                                prefs.getString('username')) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditEventPage(
                                      eventKey: eventKey,
                                      eventName: eventName,
                                      description: description,
                                      eventLocation: eventLocation,
                                      eventDate: eventDate,
                                      timeStart: timeStart,
                                      timeEnd: timeEnd,
                                      beacon: beaconUUID,
                                      major: major,
                                      minor: minor)));
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "You don't have permission to edit the event",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                              );
                            }
                          },
                        )
                      : Text("");
                }
              },
            )
          ],
        ),
        floatingActionButton: StreamBuilder(
            stream: descQuery,
            builder: (context, snapshot) {
              List<DocumentSnapshot> eventDesc = snapshot.data.documents;
              DateTime eventDate = eventDesc[0].data['eventDate'],
                  eventTimeStart = eventDesc[0].data['timeStart'],
                  eventTimeEnd = eventDesc[0].data['timeEnd'];
              String beaconID = eventDesc[0].data['beaconUUID'].toString(),
                  major = eventDesc[0].data['Major'].toString(),
                  minor = eventDesc[0].data['Minor'].toString(),
                  eventKey = eventDesc[0].documentID.toString();

              if (!snapshot.hasData)
                return Text("Loading...");
              else {
                return DateTime.now()
                        .isAfter(eventTimeEnd.add(Duration(minutes: 5)))
                    ? SizedBox()
                    : DateTime.now()
                            .isAfter(eventTimeStart.add(Duration(minutes: 30)))
                        ? SizedBox()
                        : new AttendanceFAB(
                            eventTimeStart: eventTimeStart,
                            eventTimeEnd: eventTimeEnd,
                            eventKey: eventKey,
                            descPage: widget,
                            beaconID: beaconID,
                            major: major,
                            minor: minor,
                            eventDate: eventDate);
              }
            }),
        body: DescBody(
          eventTitle: widget.eventTitle,
          username: widget.username,
        ));
  }
}

class AttendanceFAB extends StatelessWidget {
  const AttendanceFAB({
    Key key,
    @required this.eventTimeStart,
    @required this.eventTimeEnd,
    @required this.eventKey,
    @required this.descPage,
    @required this.beaconID,
    @required this.major,
    @required this.minor,
    @required this.eventDate,
  }) : super(key: key);

  final DateTime eventTimeStart;
  final DateTime eventTimeEnd;
  final String eventKey;
  final DescPage descPage;
  final String beaconID;
  final String major;
  final String minor;
  final DateTime eventDate;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: Colors.red[200],
        icon: Icon(Icons.event),
        label: Text(
          DateTime.now().isAfter(eventTimeStart.subtract(Duration(minutes: 5)))
              ? "Attendance IN"
              : DateTime.now().isAfter(eventTimeEnd)
                  ? "Attendance Out"
                  : "Attendance In",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (DateTime.now()
                  .isAfter(eventTimeStart.subtract(Duration(minutes: 5))) &&
              DateTime.now().isBefore(eventTimeEnd)) {
            await FlutterScanBluetooth.startScan(pairedDevices: false)
                .catchError((e) => print(e))
                .whenComplete(
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MonitoringTab(
                              eventKey: eventKey,
                              eventTitle: descPage.eventTitle,
                              beaconID: beaconID,
                              major: major,
                              minor: minor,
                              eventDateStart: eventDate,
                              eventTimeStart: eventTimeStart,
                              eventTimeEnd: eventTimeEnd,
                            ))));
          } else if (DateTime.now().isAfter(eventTimeEnd)) {
            await FlutterScanBluetooth.startScan(pairedDevices: false)
                .catchError((e) => print(e))
                .whenComplete(
                    () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OMonitoringTab(
                              eventKey: eventKey,
                              eventTitle: descPage.eventTitle,
                              beaconID: beaconID,
                              major: major,
                              minor: minor,
                              eventDateStart: eventDate,
                              eventTimeStart: eventTimeStart,
                              eventTimeEnd: eventTimeEnd,
                            ))));
          } else {
            print("Event is not open yet");
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("CLOSED"),
                    content:
                        Text("The event may not be available at the moment"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Okay"),
                      )
                    ],
                  ),
            );
          }
          // onPressed: () {
          //   //Directs to to ConnectBeacon if the date is today.
        });
  }
}

class DescBody extends StatelessWidget {
  final String eventTitle, username;

  DescBody({this.eventTitle, this.username});

  @override
  Widget build(BuildContext context) {
    final descQuery = Firestore.instance
        .collection('events')
        .where('eventName', isEqualTo: eventTitle)
        .snapshots();
    return StreamBuilder(
      stream: descQuery,
      builder: (context, snapshot) {
        final List<DocumentSnapshot> docs = snapshot.data.documents;
        if (!snapshot.hasData && snapshot.hasError && docs.isNotEmpty)
          return Center(child: Text("Loading..."));
        else {
          return DescListView(
            descDocuments: snapshot.data.documents,
            username: username,
          );
        }
      },
    );
  }
}

class DescListView extends StatelessWidget {
  final List<DocumentSnapshot> descDocuments;
  final String username;
  DescListView({this.descDocuments, this.username});

  @override
  Widget build(BuildContext context) {
    String organization = descDocuments[0].data['organization'].toString();
    String eventDesc = descDocuments[0].data['eventDesc'].toString();
    DateTime eventTimeStart = descDocuments[0].data['timeStart'];
    DateTime eventTimeEnd = descDocuments[0].data['timeEnd'];
    String eventLocation = descDocuments[0].data['eventLocation'].toString();
    String adminName = descDocuments[0].data['Admin'].toString();
    String imageURL = descDocuments[0].data['eventPicURL'].toString();
    String eventTitle = descDocuments[0].data['eventName'].toString();

    DateTime eventDate = descDocuments[0].data['timeStart'];
    String eventKey = descDocuments[0].documentID;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: CachedNetworkImage(
                imageUrl: imageURL,
                placeholder: CircularProgressIndicator(),
              ),
            ),
            DateTime.now().isAfter(eventTimeEnd.add(Duration(hours: 1)))
                ? SizedBox()
                : Positioned(
                    child: FavButton(
                        username: username,
                        eventTitle: eventTitle,
                        eventKey: eventKey,
                        eventDate: eventDate),
                    bottom: 0.0,
                    right: 4.0,
                  )
          ]),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Description: $eventDesc",
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Organization: $organization",
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            "Location: $eventLocation",
            style: Theme.of(context).textTheme.title,
          ),
          Text(
              "Time: ${DateFormat.jm().format(eventTimeStart)} - ${DateFormat.jm().format(eventTimeEnd)}",
              style: Theme.of(context).textTheme.title),
          SizedBox(),
          Text(
            "Event Date: ${DateFormat.yMMMd().format(eventTimeStart)}",
            style: Theme.of(context).textTheme.title,
          ),
          adminName != null ? Text("Created by: $adminName") : Text(""),
        ],
      ),
    );
  }
}

/// I want to make an algorithm for this one,Let's say the user has clicked the **Attend**
/// Then it will be passed to `${widget.eventKey}_attendees`, It will be added to the list for THAT attendee.

class FavButton extends StatefulWidget {
  final String eventTitle, eventKey, username;
  final DateTime eventDate;
  FavButton({this.eventTitle, this.eventKey, this.username, this.eventDate});
  FavButtonState createState() => FavButtonState();
}

class FavButtonState extends State<FavButton> {
  bool isAttending = false;
  int notif = 0;

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<bool> eventAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isAttending == true) {
      prefs.setBool('IsAttending', isAttending);

      /// Will be registered as an attendee in that event
      Map<String, dynamic> setAttendees = {
        'eventID': widget.eventKey,
        "eventName": widget.eventTitle,
        "userid": prefs.getString('userid'),
        "username": prefs.getString('username'),
        "TimeIn": null,
        "TimeOut": null,
      };
      DocumentReference attendEvent = Firestore.instance.document(
          '${widget.eventKey}_attendees/${prefs.getString('userid')}');
      String date = DateFormat.yMMMd().format(widget.eventDate);
      Firestore.instance.runTransaction((tx) async {
        DocumentSnapshot snapshot = await tx.get(attendEvent);
        if (!snapshot.exists) {
          await tx.set(attendEvent, setAttendees);
          await Fluttertoast.showToast(
              msg: "You will be notified at $date",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG);

          AndroidNotificationDetails androidNotification =
              AndroidNotificationDetails('your channel id', 'your channel name',
                  'your channel description',
                  importance: Importance.Max, priority: Priority.Low);
          IOSNotificationDetails iosNotification = IOSNotificationDetails();
          NotificationDetails notifDetails =
              NotificationDetails(androidNotification, iosNotification);
          date != DateFormat.yMMMd().format(DateTime.now())
              ? localNotificationsPlugin.schedule(
                  notif++,
                  widget.eventTitle,
                  "You have an event to attend, please be on time of the event",
                  widget.eventDate,
                  notifDetails)
              : await localNotificationsPlugin.schedule(
                  notif++,
                  widget.eventTitle,
                  "You have an event to attend!",
                  widget.eventDate.subtract(Duration(hours: 10)),
                  notifDetails);
        }

        print("Attended Event");
      });
    } else {
      prefs.setBool('IsAttending', isAttending);

      DocumentReference deleteAttendees = Firestore.instance.document(
          "${widget.eventKey}_attendees/${prefs.getString('userid')}");
      deleteAttendees.delete();
      print("Didn't attend");
    }
    return isAttending;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('${widget.eventKey}_attendees')
            .where("username", isEqualTo: widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          List<DocumentSnapshot> hasAttended = snapshot.data.documents;
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (hasAttended.isEmpty) {
            return RaisedButton(
              color: Colors.green[200],
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite_border,
                    color: Colors.white70,
                  ),
                  Text(
                    "Attend",
                    style: Theme.of(context).textTheme.title,
                  )
                ],
              ),
              onPressed: () {
                this.setState(() {
                  isAttending = true;
                  eventAttendance();
                });
              },
              shape: StadiumBorder(),
            );
          } else {
            return RaisedButton(
              color: Colors.green[200],
              child: Row(
                children: <Widget>[
                  Icon(Icons.favorite, color: Colors.red[200]),
                  Text(
                    "Attending",
                    style: Theme.of(context).textTheme.title,
                  )
                ],
              ),
              onPressed: () {
                if (DateTime.now()
                    .isAfter(widget.eventDate.add(Duration(minutes: 5)))) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: Text("Cannot Cancel ${widget.eventTitle}"),
                              content: Text(
                                  "Please contact the admin to cancel your registration"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Okay"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ]));
                } else {
                  this.setState(() {
                    isAttending = false;
                    eventAttendance();
                  });
                }

                // Firestore.instance.runTransaction(transactionHandler)
              },
              shape: StadiumBorder(),
            );
          }
        });
  }
}

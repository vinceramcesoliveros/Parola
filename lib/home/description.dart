import 'dart:async';

import 'package:final_parola/beacon/beacon_event.dart';
import 'package:final_parola/events/edit_events.dart';
import 'package:final_parola/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DescPage extends StatefulWidget {
  final String eventTitle, eventKey, username;

  DescPage({this.eventTitle, this.eventKey, this.username});

  @override
  DescPageState createState() {
    return new DescPageState();
  }
}

class DescPageState extends State<DescPage> {
  @override
  Widget build(BuildContext context) {
    final descQuery = Firestore.instance
        .collection('events')
        .where('eventName', isEqualTo: widget.eventTitle)
        .snapshots();
    return ScopedModel(
        model: NotificationModel(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              centerTitle: true,
              title: Text(widget.eventTitle),
              actions: <Widget>[
                StreamBuilder(
                  stream: descQuery,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text("");
                    return IconButton(
                      icon: Icon(FontAwesomeIcons.solidEdit),
                      onPressed: () async {
                        String description = snapshot
                            .data.documents[0].data['eventDesc']
                            .toString();
                        String eventName = snapshot
                            .data.documents[0].data['eventName']
                            .toString();
                        String eventLocation = snapshot
                            .data.documents[0].data['eventLocation']
                            .toString();
                        String timeEnd = snapshot
                            .data.documents[0].data['timeEnd']
                            .toString();
                        String timeStart = snapshot
                            .data.documents[0].data['timeStart']
                            .toString();
                        String eventDate = snapshot
                            .data.documents[0].data['eventDate']
                            .toString();
                        String major =
                            snapshot.data.documents[0].data['Major'].toString();
                        String minor =
                            snapshot.data.documents[0].data['Minor'].toString();
                        String beaconUUID = snapshot
                            .data.documents[0].data['beaconUUID']
                            .toString();
                        String eventKey =
                            snapshot.data.documents[0].documentID.toString();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (snapshot.data.documents[0].data['Admin'] ==
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
                            msg: "You don't have permission to edit the event",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                          );
                        }
                      },
                    );
                  },
                )
              ],
            ),
            floatingActionButton: StreamBuilder(
                stream: descQuery,
                builder: (context, snapshot) {
                  return FloatingActionButton.extended(
                      backgroundColor: Colors.red[200],
                      icon: Icon(Icons.event),
                      label: Text("Attend Event"),
                      onPressed: () async {
                        String eventToday =
                            snapshot.data.documents[0].data['eventDate'];
                        if (eventToday ==
                            DateFormat.yMMMd().format(DateTime.now())) {
                          await FlutterScanBluetooth.startScan(pairedDevices: false)
                              .catchError((e) => print(e))
                              .whenComplete(() => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MonitoringTab(
                                          eventKey: widget.eventKey,
                                          eventTitle: widget.eventTitle,
                                          beaconID: snapshot.data.documents[0]
                                              .data['beaconUUID']
                                              .toString(),
                                          major: snapshot
                                              .data.documents[0].data['Major']
                                              .toString(),
                                          minor: snapshot
                                              .data.documents[0].data['Minor']
                                              .toString()))));
                        }
                        // onPressed: () {
                        //   //Directs to to ConnectBeacon if the date is today.
                      });
                }),
            body: DescBody(
              eventTitle: widget.eventTitle,
              username: widget.username,
            )));
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
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return DescListView(
          descDocuments: snapshot.data.documents,
          username: username,
        );
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
    String eventDesc = descDocuments[0].data['eventDesc'].toString();
    String eventTimeStart = descDocuments[0].data['timeStart'].toString();
    String eventTimeEnd = descDocuments[0].data['timeEnd'].toString();
    String eventLocation = descDocuments[0].data['eventLocation'].toString();
    String adminName = descDocuments[0].data['Admin'].toString();
    String imageURL = descDocuments[0].data['eventPicURL'].toString();
    String eventTitle = descDocuments[0].data['eventName'].toString();
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
              ),
            ),
            Positioned(
              child: FavButton(
                username: username,
                eventTitle: eventTitle,
                eventKey: eventKey,
              ),
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
            "Location: $eventLocation",
            style: Theme.of(context).textTheme.title,
          ),
          Text("Time: $eventTimeStart - $eventTimeEnd",
              style: Theme.of(context).textTheme.title),
          adminName != "null" ? Text("Created by: $adminName") : Text("")
        ],
      ),
    );
  }
}

/// I want to make an algorithm for this one,Let's say the user has clicked the **Attend**
/// Then it will be passed to `ListFor$eventName`, It will be added to the list for THAT attendee.
///
class FavButton extends StatefulWidget {
  final String eventTitle, eventKey, username;
  FavButton({this.eventTitle, this.eventKey, this.username});
  FavButtonState createState() => FavButtonState();
}

class FavButtonState extends State<FavButton> {
  bool isAttending = false;

  Future<bool> eventAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isAttending) {
      prefs.setBool('IsAttending', isAttending);
      Map<String, dynamic> status = {
        "Connected": false,
        "Distance": null,
      };
      Map<String, dynamic> setAttendees = {
        "Name": prefs.getString('username'),
        "status": status,
        "In": null,
        "Out": null,
      };
      DocumentReference attendEvent = Firestore.instance
          .document('ListFor${widget.eventTitle}/${prefs.getString('userid')}');
      Firestore.instance.runTransaction((tx) async {
        DocumentSnapshot snapshot = await tx.get(attendEvent);
        if (!snapshot.exists) {
          await tx.set(attendEvent, setAttendees);
        } else {
          await tx.update(attendEvent, setAttendees);
        }
        print("Attended Event");
      });
    } else {
      prefs.setBool('IsAttending', isAttending);

      DocumentReference deleteAttendees = Firestore.instance
          .collection('ListFor${widget.eventTitle}')
          .document(prefs.getString('userid'));
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
            .collection('ListFor${widget.eventTitle}')
            .where('Name', isEqualTo: widget.username)
            .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Text("Loading...");
          if (snapshot.data.documents.isEmpty) {
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
                this.setState(() {
                  isAttending = false;
                  eventAttendance();
                });
                // Firestore.instance.runTransaction(transactionHandler)
              },
              shape: StadiumBorder(),
            );
          }
        });
  }
}

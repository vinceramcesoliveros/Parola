import 'dart:async';

import 'package:final_parola/beacon/beacon_event.dart';
import 'package:final_parola/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DescPage extends StatefulWidget {
  final String eventTitle;

  DescPage({this.eventTitle});

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
            ),
            floatingActionButton: StreamBuilder(
                stream: descQuery,
                builder: (context, snapshot) {
                  return FloatingActionButton.extended(
                    backgroundColor: Colors.red[200],
                    icon: Icon(Icons.event),
                    label: Text("Attend Event"),
                    onPressed: () async {
                      // if (eventToday ==
                      //     DateFormat.yMMMd().format(DateTime.now())) {
                      await FlutterScanBluetooth.startScan(pairedDevices: false)
                          .catchError((e) => print(e))
                          .whenComplete(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MonitoringTab(
                                      eventTitle: widget.eventTitle,
                                      beaconID: snapshot
                                          .data.documents[0].data['beaconUUID']
                                          .toString(),
                                      major: snapshot
                                          .data.documents[0].data['Major']
                                          .toString(),
                                      minor: snapshot
                                          .data.documents[0].data['Minor']
                                          .toString()))));
                    },
                    // onPressed: () {
                    //   //Directs to to ConnectBeacon if the date is today.

                    // }
                  );
                }),
            body: DescBody(
              eventTitle: widget.eventTitle,
            )));
  }
}

class DescBody extends StatelessWidget {
  final String eventTitle;

  DescBody({this.eventTitle});

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
        );
      },
    );
  }
}

class DescListView extends StatelessWidget {
  final List<DocumentSnapshot> descDocuments;
  DescListView({this.descDocuments});
  @override
  Widget build(BuildContext context) {
    String eventDesc = descDocuments[0].data['eventDesc'].toString();
    String eventTimeStart = descDocuments[0].data['timeStart'].toString();
    String eventTimeEnd = descDocuments[0].data['timeEnd'].toString();
    String eventLocation = descDocuments[0].data['eventLocation'].toString();
    String adminName = descDocuments[0].data['Admin'].toString();
    String imageURL = descDocuments[0].data['eventPicURL'].toString();
    String eventTitle = descDocuments[0].data['eventName'].toString();
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
                eventTitle: eventTitle,
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
            style: TextStyle(fontSize: 24.0),
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

class FavButton extends StatefulWidget {
  final String eventTitle;
  FavButton({this.eventTitle});
  FavButtonState createState() => FavButtonState();
}

class FavButtonState extends State<FavButton> {
  bool isAttending;
  Future<bool> hasAttended() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getBool('isAttending') != null) {
        isAttending = true;
      } else {
        isAttending = false;
      }
    });
    return isAttending;
  }

  Future<bool> eventAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isAttending) {
      prefs.setBool('IsAttending', isAttending);
      Map<String, dynamic> status = {
        "Connected": false,
        "Distance": null,
      };
      Map<String, dynamic> setAttendees = {
        "${prefs.getString('userid')}": {
          "Name": prefs.getString('username'),
          "status": status
        }
      };
      DocumentReference attendEvent =
          Firestore.instance.document('EventAttendees/${widget.eventTitle}');
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

      Map<String, dynamic> deleteAttendee = {
        "${prefs.getString('userid')}": FieldValue.delete()
      };
      DocumentReference deleteAttendees = Firestore.instance
          .collection('EventAttendees')
          .document(widget.eventTitle);

      deleteAttendees.updateData(deleteAttendee);
      print("Didn't attend");
    }
    return isAttending;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.hasAttended();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.green[200],
      child: Row(
        children: <Widget>[
          Icon(
            isAttending == false ? Icons.favorite_border : Icons.favorite,
            color: isAttending == true ? Colors.red[200] : Colors.white70,
          ),
          Text(
            isAttending == false ? "Attend" : "Attending",
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
      onPressed: () {
        this.setState(() {
          isAttending = !isAttending;
          eventAttendance();
        });
        // Firestore.instance.runTransaction(transactionHandler)
      },
      shape: StadiumBorder(),
    );
  }
}

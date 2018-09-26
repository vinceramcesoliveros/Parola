import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendedEvents extends StatelessWidget {
  final String user, eventKey, eventName;
  AttendedEvents({this.user, this.eventKey, this.eventName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attended Events"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: AttendedEventBody(user: user),
    );
  }
}

class AttendedEventBody extends StatefulWidget {
  final String user, eventName, eventKey;
  AttendedEventBody({this.user, this.eventName, this.eventKey});

  @override
  AttendedEventBodyState createState() {
    return new AttendedEventBodyState();
  }
}

class AttendedEventBodyState extends State<AttendedEventBody> {
  String userid;
  List<String> eventLists = new List();
  Future<String> queryEvents({String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return id = prefs.getString('userid');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryEvents(id: userid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("event_attended_${widget.eventKey}")
          .where("userid", isEqualTo: userid)
          .snapshots(),
      builder: (context, snapshot) {
        List<DocumentSnapshot> attendedEvents = snapshot.data.documents;
        if (!snapshot?.hasData) {
          return Text("Loading...");
        } else {
          return ListView.builder(
            itemCount: attendedEvents.length,
            itemBuilder: (context, index) {
              String attendanceIn = attendedEvents[index].data['In'];
              String attendanceOut =
                  attendedEvents[index].data['Out'].toString() ?? "UNATTENDED";
              String eventName =
                  attendedEvents[index].data['eventName'].toString();
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${index + 1}. $eventName"),
                    // subtitle: Row(
                    //   children: <Widget>[
                    //     Text(
                    //       "In:$attendanceIn",
                    //     ),
                    //     Icon(attendanceIn != "Absent"
                    //         ? Icons.check
                    //         : Icons.close),
                    //     Text("OUT: $attendanceOut"),
                    //     Icon(attendanceOut != "Absent"
                    //         ? Icons.check
                    //         : Icons.close)
                    //   ],
                    // ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

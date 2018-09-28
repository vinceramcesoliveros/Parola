import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<String> eventLists = new List();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("event_attended_${widget.user}")
          .where("userid", isEqualTo: widget.user)
          .snapshots(),
      builder: (context, snapshot) {
        List<DocumentSnapshot> attendedEvents = snapshot.data.documents;
        if (!snapshot.hasData) {
          return Text("Loading...");
        } else {
          return ListView.builder(
            itemCount: attendedEvents.length,
            itemBuilder: (context, index) {
              String attendanceIn = attendedEvents[index].data['In'];
              String attendanceOut =
                  attendedEvents[index].data['Out']?.toString() ?? "Absent";
              String eventName =
                  attendedEvents[index].data['eventName'].toString();
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("${index + 1}. $eventName"),
                      subtitle: Text("In: $attendanceIn Out: $attendanceOut"),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

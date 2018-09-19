import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

class AttendedEventBody extends StatelessWidget {
  final String user, eventName, eventKey;
  AttendedEventBody({this.user, this.eventName, this.eventKey});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("attended_$user").snapshots(),
      builder: (context, snapshot) {
        List<DocumentSnapshot> attendedEvents = snapshot.data.documents;
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "${index + 1}. ${attendedEvents[index].data['eventName'].toString()}"),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        "In:${attendedEvents[index].data['In'].toString()}",
                      ),
                      Icon(attendedEvents[index].data['In'].toString() !=
                              "Absent"
                          ? Icons.check
                          : Icons.close),
                      Text(
                          "OUT: ${attendedEvents[index].data['Out'].toString()}"),
                      Icon(attendedEvents[index].data['Out'].toString() !=
                              "Half-Completed"
                          ? Icons.check
                          : Icons.close)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

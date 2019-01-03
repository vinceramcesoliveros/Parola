import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingEvents extends StatelessWidget {
  final String user;
  UpcomingEvents({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Upcoming Events"),
          centerTitle: true,
          backgroundColor: Colors.green[200]),
      body: UpcomingEventBody(),
    );
  }
}

class UpcomingEventBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("No events Today"));
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              List<DocumentSnapshot> eventListDocuments =
                  snapshot.data.documents;
              DateTime eventDate = eventListDocuments[index].data['timeStart'];
              String eventName =
                  eventListDocuments[index].data['eventName'].toString();
              if (DateFormat.yMMMd().format(eventDate) ==
                  DateFormat.yMMMd().format(DateTime.now())) {
                return Card(
                  child: ListTile(
                    title: Text(eventName),
                    subtitle:
                        Text(DateFormat.yMMMd().format(eventDate).toString()),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

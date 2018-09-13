import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEvents extends StatelessWidget {
  final String adminName;
  AdminEvents({this.adminName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Events"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 30,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .where('Admin', isEqualTo: adminName)
                  .snapshots(),
              builder: (context, freshSnap) {
                if (!freshSnap.hasData) return LinearProgressIndicator();
                return ListOfEvents(eventRef: freshSnap.data.documents);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListOfEvents extends StatelessWidget {
  final List<DocumentSnapshot> eventRef;
  ListOfEvents({this.eventRef});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventRef.length,
      itemBuilder: (context, index) {
        Future<void> deleteEvents({String eventKey}) async {
          await Firestore.instance
              .collection('events')
              .document(eventKey)
              .delete()
              .then((doc) {
            print("Deleted $eventKey");
          });
        }

        String eventName = eventRef[index].data['eventName'].toString();
        String eventDate = eventRef[index].data['eventDate'].toString();
        return Card(
          color: Colors.green[300],
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(16.0))),
          elevation: 16.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(eventName),
                subtitle: Text(eventDate),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async => deleteEvents(
                      eventKey: eventRef[index].documentID.toString()),
                ),
              ),
              ButtonTheme.bar(
                  child: ButtonBar(children: [
                FlatButton(
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0))),
                    color: Colors.green[600],
                    child: Text(
                      "View Attendees",
                      style: Theme.of(context).textTheme.body1,
                    ),
                    onPressed: () {}),
              ]))
            ],
          ),
        );
      },
    );
  }
}

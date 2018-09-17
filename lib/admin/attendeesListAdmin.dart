import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendeesLists extends StatelessWidget {
  final String eventName;
  final String eventKey;
  AttendeesLists({this.eventName, this.eventKey});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Attendees"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: StreamBuilder(
          stream:
              Firestore.instance.collection('ListFor$eventName').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return AttendeesListsDocuments(
                lists: snapshot.data.documents, eventName: eventName);
          }),
    );
  }
}

class AttendeesListsDocuments extends StatelessWidget {
  final List<DocumentSnapshot> lists;
  final String eventName;
  AttendeesListsDocuments({this.lists, this.eventName});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        String name = lists[index].data["Name"].toString();
        return ListTile(
          title: Text("${index + 1}. $name"),
          trailing: Icon(Icons.check),
        );
      },
    );
  }
}

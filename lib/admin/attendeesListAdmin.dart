import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Firestore.instance.collection('${eventKey}_$eventName').snapshots(),
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
        String attendanceIN = lists[index].data['In'].toString();
        String attendanceOut = lists[index].data['Out'].toString();
        return ListTile(
          title: Text("${index + 1}. $name"),
          trailing: Row(
            children: <Widget>[
              Text(attendanceIN),
              Icon(attendanceIN != "Absent" ? Icons.check : Icons.close),
              Text(attendanceOut),
              Icon(attendanceOut != "Half-Complete"
                  ? Icons.check
                  : Icons.warning)
            ],
          ),
        );
      },
    );
  }
}

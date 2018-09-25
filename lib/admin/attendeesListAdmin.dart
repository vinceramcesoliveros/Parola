import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/admin/crudAttendees.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AttendeesLists extends StatefulWidget {
  final String eventName;
  final String eventKey;
  AttendeesLists({this.eventName, this.eventKey});

  @override
  AttendeesListsState createState() {
    return new AttendeesListsState();
  }
}

class AttendeesListsState extends State<AttendeesLists> {
  List<String> attendeesLists = new List();

  Future<Null> queryEvents() async {
    Firestore.instance
        .collection('${widget.eventKey}_attendees')
        .snapshots()
        .listen((data) => data.documents
            .forEach((doc) => attendeesLists.add(doc["username"])));
  }

  void initState() {
    queryEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Attendees"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: AttendeeSearchQuery(
                      attendeesLists: attendeesLists,
                      eventKey: widget.eventKey));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add missing attendees"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAttendees(
                        eventKey: widget.eventKey,
                      )));
        },
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('${widget.eventKey}_attendees')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading..."));
            } else {
              return AttendeesListsDocuments(
                  lists: snapshot.data.documents, eventKey: widget.eventKey);
            }
          }),
    );
  }
}

class AttendeesListsDocuments extends StatelessWidget {
  final List<DocumentSnapshot> lists;
  final String eventKey;
  AttendeesListsDocuments({this.lists, this.eventKey});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        String id = lists[index].documentID.toString();
        String name = lists[index].data["username"].toString();
        String attendanceIN = lists[index].data['In']?.toString();
        String attendanceOut = lists[index].data['Out']?.toString();
        return Card(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              leading: Icon(Icons.person),
              trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditAttendees(
                            eventKey: eventKey,
                            id: id,
                            name: name,
                            attendIn: attendanceIN,
                            attendOut: attendanceOut,
                          )))),
              title: Text("${index + 1}. $name"),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  Text(attendanceIN == null ? "Pending" : attendanceIN),
                  Icon(attendanceIN == "Absent" || attendanceIN == null
                      ? Icons.close
                      : Icons.check),
                  Text(attendanceOut == null ? "Pending" : attendanceOut),
                  Icon(
                    attendanceOut == null || attendanceOut == "Absent"
                        ? Icons.close
                        : Icons.check,
                  )
                ],
              ),
            )
          ]),
        );
      },
    );
  }
}

class AttendeeSearchQuery extends SearchDelegate<String> {
  final List<String> attendeesLists;
  final String eventKey;
  AttendeeSearchQuery({this.attendeesLists, this.eventKey});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchQuery = attendeesLists.isEmpty
        ? attendeesLists
        : attendeesLists.where((p) => p.startsWith(query)).toSet().toList();
    return attendeesLists == null
        ? ListTile(
            title: Text("Search Attendee"),
          )
        : ListView.builder(
            itemCount: searchQuery.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  query = searchQuery[0];
                  showResults(context);
                },
                title: RichText(
                    text: TextSpan(
                        text: searchQuery[index].substring(0, query.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: searchQuery[index].substring(query.length),
                          style: TextStyle(color: Colors.white70))
                    ])),
                leading: Icon(Icons.person),
              );
            },
          );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/admin/crudAttendees.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendeesLists extends StatefulWidget {
  final String eventName;
  final String eventKey;
  final DateTime endTime;
  AttendeesLists({this.eventName, this.eventKey, this.endTime});

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
        title: Text(
            "No. of Attendees: ${attendeesLists.isEmpty ? 0 : attendeesLists.length + 1}"),
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
          ),
        ],
      ),
      floatingActionButton:
          DateTime.now().isAfter(widget.endTime.add(Duration(minutes: 30)))
              ? SizedBox()
              : FloatingActionButton(
                  child: Icon(Icons.add),
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
            if (!snapshot.hasData || snapshot.data.documents == null) {
              return Center(child: Text("Loading..."));
            } else {
              return AttendeesListsDocuments(
                  lists: snapshot.data.documents,
                  eventKey: widget.eventKey,
                  endTime: widget.endTime);
            }
          }),
    );
  }
}

class AttendeesListsDocuments extends StatelessWidget {
  final List<DocumentSnapshot> lists;
  final String eventKey;
  final DateTime endTime;
  AttendeesListsDocuments({this.lists, this.eventKey, this.endTime});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      itemBuilder: (context, index) {
        String id = lists[index].documentID.toString();
        String name = lists[index].data["username"].toString();
        String attendanceIN = lists[index].data['In']?.toString();
        String attendanceOut = lists[index].data['Out']?.toString();
        DateTime timeIn = lists[index].data['TimeIn'];
        DateTime timeOut = lists[index].data['TimeOut'];
        return Card(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              leading: Icon(Icons.person),
              trailing:
                  DateTime.now().isAfter(endTime.add(Duration(minutes: 30)))
                      ? SizedBox()
                      : IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
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
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(attendanceIN == null
                      ? DateTime.now().isAfter(timeOut)
                          ? "Absent"
                          : attendanceIN == "Pending"
                      : "$attendanceIN - Time In: ${DateFormat.jm().format(timeIn)}"),
                  Icon(attendanceIN == "Absent" || attendanceIN == null
                      ? Icons.close
                      : Icons.check),
                  Text(attendanceOut == null
                      ? DateTime.now().isAfter(timeOut) ? "Absent" : "Pending"
                      : attendanceOut),
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

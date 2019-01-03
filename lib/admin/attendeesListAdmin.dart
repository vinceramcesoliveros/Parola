import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/admin/crudAttendees.dart';
import 'package:flutter/material.dart';

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
          ),
        ],
      ),
      floatingActionButton:
          DateTime.now().isAfter(widget.endTime.add(Duration(minutes: 30)))
              ? SizedBox()
              : new FABAttendees(widget: widget),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('${widget.eventKey}_attendees')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return AttendeesListsDocuments(
                lists: snapshot.data.documents,
                eventKey: widget.eventKey,
                endTime: widget.endTime);
          }),
    );
  }
}

class FABAttendees extends StatelessWidget {
  const FABAttendees({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final AttendeesLists widget;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddAttendees(
                      eventKey: widget.eventKey,
                    )));
      },
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
        List<DocumentSnapshot> listOfAttendees = lists;
        String id = listOfAttendees[index].data['eventID'].toString();
        String name = listOfAttendees[index].data["username"].toString();
        String attendanceIN = listOfAttendees[index].data['In']?.toString();
        String attendanceOut = listOfAttendees[index].data['Out']?.toString();
        return Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.person),
              trailing:
                  DateTime.now().isAfter(endTime.add(Duration(minutes: 30)))
                      ? SizedBox()
                      : new EventIcon(
                          eventKey: eventKey,
                          id: id,
                          name: name,
                          attendanceIN: attendanceIN,
                          attendanceOut: attendanceOut),
              title: Text("${index + 1}. $name"),
            ));
      },
    );
  }
}

class EventIcon extends StatelessWidget {
  const EventIcon({
    Key key,
    @required this.eventKey,
    @required this.id,
    @required this.name,
    @required this.attendanceIN,
    @required this.attendanceOut,
  }) : super(key: key);

  final String eventKey;
  final String id;
  final String name;
  final String attendanceIN;
  final String attendanceOut;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditAttendees(
                  eventKey: eventKey,
                  id: id,
                  name: name,
                  attendIn: attendanceIN,
                  attendOut: attendanceOut,
                ))));
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

  Widget noResult = ListTile(
    title: Text("Search Attendee"),
  );
  @override
  Widget buildSuggestions(BuildContext context) {
    final searchQuery = attendeesLists.isEmpty
        ? attendeesLists
        : attendeesLists.where((p) => p.startsWith(query)).toSet().toList();
    return attendeesLists == null
        ? noResult
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

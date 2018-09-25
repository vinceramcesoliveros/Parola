import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/admin/crudAttendees.dart';
import 'package:flutter/material.dart';

class AttendeesLists extends StatefulWidget {
  final String eventName;
  final String eventKey;
  final DateTime eventEnd;
  AttendeesLists({this.eventName, this.eventKey, this.eventEnd});

  @override
  AttendeesListsState createState() {
    return new AttendeesListsState();
  }
}

class AttendeesListsState extends State<AttendeesLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Attendees"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      floatingActionButton:
          widget.eventEnd.isAfter(widget.eventEnd.add(Duration(hours: 1)))
              ? FloatingActionButton.extended(
                  label: Text("Record Attendance"),
                  icon: Icon(Icons.assignment),
                  onPressed: () {
                    //Record attendees will set all the data to each attendees
                    // and will not change overtime.
                  },
                  backgroundColor: Colors.red[300],
                )
              : widget.eventEnd.isBefore(widget.eventEnd)
                  ? FloatingActionButton.extended(
                      backgroundColor: Colors.green[300],
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
                    )
                  : SizedBox(),
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
        String id = lists[index].data['eventID'].toString();
        String distance = lists[index].data['Distance']?.toString();
        String name = lists[index].data["username"].toString();
        String attendanceIN = lists[index].data['In']?.toString();
        String attendanceOut = lists[index].data['Out']?.toString();
        return Card(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              subtitle: Text(distance ?? "No distance"),
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

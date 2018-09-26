import 'package:final_parola/admin/attendeesListAdmin.dart';
import 'package:final_parola/home/description.dart';
import 'package:final_parola/model/crud_events.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminEvents extends StatelessWidget {
  final String userid;
  AdminEvents({this.userid});
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
                  .where('userid', isEqualTo: userid)
                  .snapshots(),
              builder: (context, freshSnap) {
                if (!freshSnap.hasData)
                  return SpinKitChasingDots(
                    color: Colors.red[200],
                  );
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
        String eventName = eventRef[index].data['eventName'].toString();
        String eventKey = eventRef[index].documentID.toString();
        String eventDate = eventRef[index].data['eventDate'].toString();
        return new EventDetails(
            eventName: eventName, eventDate: eventDate, eventKey: eventKey);
      },
    );
  }
}

class EventDetails extends StatelessWidget {
  const EventDetails({
    Key key,
    @required this.eventName,
    @required this.eventDate,
    @required this.eventKey,
  }) : super(key: key);

  final String eventName;
  final String eventDate;
  final String eventKey;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ParolaFirebase(),
      child: Card(
        color: Colors.green[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        elevation: 16.0,
        child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => DescPage(
                          eventTitle: eventName,
                          username: prefs.getString('username'),
                        )),
                (p) => true);
          },
          child: new EventViewDetails(
              eventName: eventName, eventDate: eventDate, eventKey: eventKey),
        ),
      ),
    );
  }
}

class EventViewDetails extends StatelessWidget {
  const EventViewDetails({
    Key key,
    @required this.eventName,
    @required this.eventDate,
    @required this.eventKey,
  }) : super(key: key);

  final String eventName;
  final String eventDate;
  final String eventKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new EventNameModel(
            eventName: eventName, eventDate: eventDate, eventKey: eventKey),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendeesLists(
                              eventKey: eventKey,
                              eventName: eventName,
                            )));
              }),
        ]))
      ],
    );
  }
}

class EventNameModel extends StatelessWidget {
  const EventNameModel({
    Key key,
    @required this.eventName,
    @required this.eventDate,
    @required this.eventKey,
  }) : super(key: key);

  final String eventName;
  final String eventDate;
  final String eventKey;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ParolaFirebase>(
        rebuildOnChange: false,
        builder: (context, child, model) {
          return ListTile(
            title: Text(eventName),
            subtitle: Text(eventDate),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () async => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Delete $eventName ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        content:
                            Text("Are you sure want to Delete $eventName ?"),
                        actions: <Widget>[
                          RaisedButton(
                              color: Colors.red[200],
                              child: Text(
                                "Delete Event",
                                style: Theme.of(context).textTheme.title,
                              ),
                              onPressed: () async {
                                model
                                    .deleteEvents(
                                        eventName: eventName,
                                        eventKey: eventKey)
                                    .whenComplete(
                                        () => Navigator.of(context).pop());
                              }),
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("NO"))
                        ],
                      )),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:final_parola/events/date_time.dart';

class EventPage extends StatefulWidget {
  @override
  EventPageState createState() {
    return new EventPageState();
  }
}

class EventPageState extends State<EventPage> {
  DateTime eventDateStart = new DateTime.now();

  TimeOfDay eventTimeStart = const TimeOfDay(minute: 0, hour: 0);

  DateTime eventDateEnd = new DateTime.now();

  TimeOfDay eventTimeEnd = const TimeOfDay(minute: 0, hour: 0);

  TextEditingController eventName, eventDescription, beaconUUID, major, minor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[300],
        icon: Icon(Icons.create),
        label: Text("Create Event"),
        onPressed: () {},
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Event Name"),
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Event Description", border: OutlineInputBorder()),
            maxLines: 3,
          ),
          new EventDateTimePicker(
            labelText: 'Event Date',
            selectedDate: eventDateStart,
            eventStartTime: eventTimeStart,
            eventEndTime: eventTimeEnd,
            selectDate: (DateTime date) {
              setState(() {
                eventDateStart = date;
              });
            },
            startSelect: (TimeOfDay time) {
              setState(() {
                eventTimeStart = time;
              });
            },
            endSelect: (TimeOfDay endTime) {
              setState(() {
                eventTimeEnd = endTime;
              });
            },
          ),
          TextFormField(
            initialValue: "",
            decoration: InputDecoration(
              labelText: "Event Location",
            ),
          ),
          TextFormField(
              decoration: InputDecoration(
            labelText: "Event Location",
          )),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(child: Text("Upload Image"), onPressed: () {})
        ])),
      ),
    );
  }
}

//Pagination Page, Alternative to Stepper in Flutter.

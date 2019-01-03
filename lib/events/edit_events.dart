import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/events/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEventPage extends StatefulWidget {
  final String eventName,
      eventKey,
      major,
      minor,
      beacon,
      eventLocation,
      description,
      organization;

  final DateTime eventDate, timeStart, timeEnd;
  EditEventPage(
      {this.organization,
      this.eventKey,
      this.eventName,
      this.description,
      this.eventLocation,
      this.eventDate,
      this.timeStart,
      this.timeEnd,
      this.major,
      this.minor,
      this.beacon});
  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  TimeOfDay eventTimeStart = const TimeOfDay(minute: 0, hour: 0);
  TimeOfDay eventTimeEnd = const TimeOfDay(minute: 0, hour: 0);
  String eventName,
      major,
      minor,
      beacon,
      eventLocation,
      description,
      organization;

  DateTime eventDate = DateTime.now(),
      timeEnd = DateTime.now(),
      timeStart = DateTime.now();
  GlobalKey<FormState> eventKey = GlobalKey<FormState>();

  void submitEvent() {
    final form = eventKey.currentState;
    if (form.validate() &&
        eventDate != null &&
        eventTimeStart != null &&
        eventTimeEnd != null) {
      form.save();
      editEvent();
    }
  }

Future<Null> editEvent() async {
DateTime finalStartDate = new DateTime(eventDate.year, eventDate.month,
eventDate.day, timeStart.hour, timeStart.minute);
DateTime finalEndDate = new DateTime(eventDate.year, eventDate.month,
eventDate.day, timeEnd.hour, timeEnd.minute);
Map<String, dynamic> eventData = {
"eventName": eventName,
"eventDesc": description,
"eventDate": eventDate,
"eventLocation": eventLocation,
"timeStart": finalStartDate,
"timeEnd": finalEndDate,
"beaconUUID": beacon,
"Major": major,
"Minor": minor,
"organization": organization
};
final DocumentReference ref =
Firestore.instance.collection('events').document(widget.eventKey);
Firestore.instance.runTransaction((trans) async {
await trans.update(ref, eventData);
}).then((result) {
print(result);

Navigator.of(context).pop();
});
}

  @override
  Widget build(BuildContext context) {
    MaskedTextController beaconController = MaskedTextController(
        mask: '@@@@@@@@-@@@@-@@@@-@@@@-@@@@@@@@@@@@', text: widget.beacon);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[300],
        icon: Icon(FontAwesomeIcons.solidEdit),
        label: Text(
          "Edit Event",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          submitEvent();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text("Edit Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: eventKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: widget.eventName,
                    decoration: InputDecoration(labelText: "Event Name"),
                    onSaved: (str) {
                      eventName = str;
                    },
                    validator: (val) =>
                        val.isEmpty ? 'Event Title can\'t be empty' : null,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    initialValue: widget.description,
                    decoration: InputDecoration(
                        labelText: "Event Description",
                        border: OutlineInputBorder()),
                    maxLines: 3,
                    onSaved: (str) {
                      description = str;
                    },
                  ),
                ),
                EventDateTimePicker(
                  labelText: 'Event Date',
                  selectedDate: eventDate,
                  eventStartTime: eventTimeStart,
                  eventEndTime: eventTimeEnd,
                  selectDate: (DateTime date) {
                    setState(() {
                      eventDate = date;
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: widget.eventLocation,
                          maxLength: 50,
                          decoration: InputDecoration(
                            labelText: "Event Location",
                          ),
                          onSaved: (str) {
                            eventLocation = str;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: widget.organization,
                          decoration: InputDecoration(
                              labelText: "Organization",
                              labelStyle: Theme.of(context).textTheme.body1),
                          onSaved: (str) => organization = str,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: beaconController,
                          maxLength: 36,
                          decoration: InputDecoration(
                              labelText: "Beacon UUID",
                              labelStyle: Theme.of(context).textTheme.body1),
                          onSaved: (str) => beacon = str,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            initialValue: widget.major,
                            maxLength: 4,
                            onSaved: (str) => major = str,
                            decoration: InputDecoration(
                                labelText: "Major",
                                labelStyle: Theme.of(context).textTheme.body1)),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            initialValue: widget.minor,
                            maxLength: 4,
                            onSaved: (str) => minor = str,
                            decoration: InputDecoration(
                                labelText: "Minor",
                                labelStyle: Theme.of(context).textTheme.body1)),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

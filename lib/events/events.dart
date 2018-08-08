import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/events/events.dart
=======
<<<<<<< HEAD
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
>>>>>>> master:lib/events.dart

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Form(
          child: EventForm(),
        ),
      ),
    );
  }
}

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

//TODO: Finalize the UI for creating Events
//Implement BLoC pattern for this. this is a horrible code.
class _EventFormState extends State<EventForm> {
  TextEditingController eventName,
      eventDescription,
      eventDate,
      eventTime,
      beaconUUID,
      major,
      minor;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: "",
          controller: eventName,
          decoration: InputDecoration(
              icon: Icon(Icons.description),
              labelText: "Event Name",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 32.0),
        ),
        TextFormField(
          initialValue: "",
          controller: eventDescription,
          decoration: InputDecoration(
              icon: Icon(Icons.text_fields),
              labelText: "Event Description",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: eventDate,
          decoration: InputDecoration(
              icon: Icon(Icons.date_range),
              labelText: "Event Date",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: beaconUUID,
          decoration: InputDecoration(
              icon: Icon(Icons.devices_other),
              labelText: "Beacon UUID",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: major,
          decoration: InputDecoration(
              icon: Icon(Icons.date_range),
              labelText: "Event Major",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: minor,
          decoration: InputDecoration(
              icon: Icon(Icons.date_range),
              labelText: "Event Date",
              border: OutlineInputBorder()),
          maxLength: 60,
        ),
      ],
    );
  }
}
=======



class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
>>>>>>> e8425145875f099ece713006bfbae761f4f05c4b

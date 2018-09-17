import 'package:final_parola/events/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final String eventName,
      eventDate,
      major,
      minor,
      beacon,
      timeEnd,
      timeStart,
      eventLocation,
      description;
  EditEventPage(
      {this.eventName,
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
  @override
  Widget build(BuildContext context) {
    String eventName = widget.eventName,
        eventDate = widget.eventDate,
        major = widget.major,
        minor = widget.minor,
        beacon = widget.beacon,
        timeEnd = widget.timeEnd,
        timeStart = widget.timeStart,
        eventLocation = widget.eventLocation,
        description = widget.description;
    eventDate = widget.eventDate;
    DateTime eventDateStart = DateFormat.yMMMd().parse(eventDate);
    TimeOfDay eventTimeStart = const TimeOfDay(minute: 0, hour: 0);
    TimeOfDay eventTimeEnd = const TimeOfDay(minute: 0, hour: 0);

    MaskedTextController beaconController = MaskedTextController(
        mask: '@@@@@@@@-@@@@-@@@@-@@@@-@@@@@@@@@@@@', text: beacon);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[300],
        icon: Icon(FontAwesomeIcons.solidEdit),
        label: Text("Edit Event"),
        onPressed: () async {},
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text("Edit Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: eventName,
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
                    initialValue: description,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: eventLocation,
                          maxLength: 50,
                          decoration: InputDecoration(
                            labelText: "Event Location",
                          ),
                          onSaved: (str) {
                            eventLocation = str;
                          },
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: DropdownButton(
                      //       hint: Text("Select Organization"),
                      //       items: orgMenu,
                      //       onChanged: (val) {}),
                      // )
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
                              hintText: "01234567-89AB-CDEF-012-3456789ABCDE",
                              labelText: "Beacon UUID",
                              labelStyle: Theme.of(context).textTheme.body1),
                          onSaved: (str) => beacon = str,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            initialValue: major,
                            maxLength: 4,
                            onSaved: (str) => major = str,
                            decoration: InputDecoration(
                                hintText: "09AF",
                                labelText: "Major",
                                labelStyle: Theme.of(context).textTheme.body1)),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            initialValue: minor,
                            maxLength: 4,
                            onSaved: (str) => minor = str,
                            decoration: InputDecoration(
                                hintText: "09AF",
                                labelText: "Minor",
                                labelStyle: Theme.of(context).textTheme.body1)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Center(child: Text("No file selected"))
              ]),
        ),
      ),
    );
  }
}

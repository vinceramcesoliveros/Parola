import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAttendees extends StatefulWidget {
  final String eventKey;
  AddAttendees({this.eventKey});
  _AddAttendeesState createState() => _AddAttendeesState();
}

class _AddAttendeesState extends State<AddAttendees> {
  String name, attendIn, attendOut;
  GlobalKey<FormState> keyAttendee = GlobalKey<FormState>();

  Future<Null> setAttendees() async {
    Map<String, String> setAttendee = {
      "username": name,
      "In": attendIn,
      "Out": attendOut
    };
    final addUser = Firestore.instance
        .collection('${widget.eventKey}_attendees')
        .document();

    addUser.setData(setAttendee).then((e) {
      print("ADDED");
    });
  }

  void addAttendees() {
    final form = keyAttendee.currentState;
    if (form.validate()) {
      form.save();
      print(name + attendIn + attendOut);
      setAttendees().whenComplete(() {
        Fluttertoast.showToast(msg: "Added $name");
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        centerTitle: true,
        title: Text("Add Attendees"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this.keyAttendee,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? "Please put name first" : null,
                    decoration: InputDecoration(hintText: "Name"),
                    onSaved: (val) => name = val,
                  ),
                  Text(
                    "Attendance In",
                    style: Theme.of(context).textTheme.title,
                  ),
                  RadioListTile(
                    title: Text("Present"),
                    value: "Present",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Absent"),
                    value: "Absent",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Late"),
                    value: "Late",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                      title: Text("Excused"),
                      value: "Excused",
                      groupValue: attendIn,
                      onChanged: (String val) {
                        setState(() {
                          attendIn = val;
                        });
                      }),
                  Text(
                    "Attendance Out",
                    style: Theme.of(context).textTheme.title,
                  ),
                  RadioListTile(
                      title: Text("Present"),
                      value: "Present",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Absent"),
                      value: "Absent",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Late"),
                      value: "Late",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Excused"),
                      value: "Excused",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  Center(
                      child: RaisedButton(
                          child: Text("Add Attendee"),
                          onPressed: addAttendees,
                          shape: StadiumBorder()))
                ]),
          ),
        ),
      ),
    );
  }
}

class EditAttendees extends StatefulWidget {
  final String eventKey, name, attendIn, attendOut, id;
  EditAttendees(
      {this.eventKey, this.attendOut, this.attendIn, this.name, this.id});
  _EditAttendeesState createState() => _EditAttendeesState();
}

class _EditAttendeesState extends State<EditAttendees> {
  GlobalKey<FormState> keyAttendee = GlobalKey<FormState>();
  String name, attendOut, attendIn, eventKey, id;

  Future<Null> setAttendees() async {
    Map<String, String> setAttendee = {
      "username": name,
      "In": attendIn,
      "Out": attendOut,
      "eventKey": widget.eventKey
    };

    final eventAttendeesQuery = Firestore.instance
        .collection('events_attended_${widget.id}')
        .document(widget.eventKey);
    final setQuery = Firestore.instance
        .collection('${widget.eventKey}_attendees')
        .document(widget.id);
    setQuery.updateData(setAttendee).then((e) {
      print("UPDATED");
      eventAttendeesQuery.updateData(setAttendee).then((e) {
        print("update attendee");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    name = widget.name;
    void updateAttendees() {
      final form = keyAttendee.currentState;
      if (form.validate()) {
        form.save();
        setAttendees().whenComplete(() {
          Fluttertoast.showToast(msg: "Updated ${widget.name}");
          Navigator.pop(context);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        centerTitle: true,
        title: Text("Add Attendees"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this.keyAttendee,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    enabled: false,
                    initialValue: widget.name,
                    validator: (val) =>
                        val.isEmpty ? "Please put name first" : null,
                    decoration: InputDecoration(hintText: "Name"),
                    onSaved: (val) => name = val,
                  ),
                  Text(
                    "Attendance In",
                    style: Theme.of(context).textTheme.title,
                  ),
                  RadioListTile(
                    title: Text("Present"),
                    value: "Present",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Absent"),
                    value: "Absent",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Late"),
                    value: "Late",
                    groupValue: attendIn,
                    onChanged: (val) {
                      setState(() {
                        attendIn = val;
                      });
                    },
                  ),
                  RadioListTile(
                      title: Text("Excused"),
                      value: "Excused",
                      groupValue: attendIn,
                      onChanged: (String val) {
                        setState(() {
                          attendIn = val;
                        });
                      }),
                  Text(
                    "Attendance Out",
                    style: Theme.of(context).textTheme.title,
                  ),
                  RadioListTile(
                      title: Text("Present"),
                      value: "Present",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Absent"),
                      value: "Absent",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Late"),
                      value: "Late",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  RadioListTile(
                      title: Text("Excused"),
                      value: "Excused",
                      groupValue: attendOut,
                      onChanged: (String val) {
                        setState(() {
                          attendOut = val;
                        });
                      }),
                  Center(
                      child: RaisedButton(
                          child: Text("Update Attendee"),
                          onPressed: updateAttendees,
                          shape: StadiumBorder()))
                ]),
          ),
        ),
      ),
    );
  }
}

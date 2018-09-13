import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:final_parola/events/date_time.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class EventPage extends StatefulWidget {
  @override
  EventPageState createState() {
    return new EventPageState();
  }
}

class EventPageState extends State<EventPage> {
  DateTime eventDateStart = new DateTime.now();
  TimeOfDay eventTimeStart = const TimeOfDay(minute: 0, hour: 0);
  TimeOfDay eventTimeEnd = const TimeOfDay(minute: 0, hour: 0);
  String eventName, eventDesc, beaconUUID, major, minor, eventLocation, path;
  final GlobalKey<FormState> eventKey = new GlobalKey<FormState>();
  File _image;

  MaskedTextController beaconController =
      MaskedTextController(mask: '@@@@@@@-@@@@-@@@@-@@@@-@@@@@@@@@@@@');
  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<Null> uploadFile(String filepath) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('eventImages/$fileName');
    final StorageUploadTask task = storageRef.putFile(file);

    final Uri downloadUrl = (await task.future).downloadUrl;
    path = downloadUrl.toString();
  }

  Future<void> showUploadTask() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 8.0,
            ),
            Text("Creating Event...")
          ],
        )));
  }

  Future<Null> addEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String admin = prefs.getString('username');

    DateTime finalStartDate = new DateTime(
        eventDateStart.year,
        eventDateStart.month,
        eventDateStart.day,
        eventTimeStart.hour,
        eventTimeStart.minute);
    DateTime finalEndDate = new DateTime(
        eventDateStart.year,
        eventDateStart.month,
        eventDateStart.day,
        eventTimeEnd.hour,
        eventTimeEnd.minute);
    String timeEnd = DateFormat.jm().format(finalEndDate);
    String timeStart = DateFormat.jm().format(finalStartDate);
    Map<String, dynamic> eventData = {
      "eventName": eventName,
      "eventDesc": eventDesc,
      "eventDate": DateFormat.yMMMd().format(eventDateStart),
      "eventLocation": eventLocation,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "eventPicURL": path,
      "beaconUUID": beaconUUID,
      "Major": major,
      "Minor": minor,
      'Admin': admin
    };
    final DocumentReference ref =
        Firestore.instance.collection('events').document();
    Firestore.instance.runTransaction((trans) async {
      await trans.set(ref, eventData);
    }).then((result) {
      printForms();
      print("Added to the Database");
      Navigator.of(context).pop();
    });
  }

  void submitEvent() async {
    final form = eventKey.currentState;
    if (form.validate() &&
        eventDateStart != null &&
        eventTimeStart != null &&
        eventTimeEnd != null) {
      form.save();
    }
  }

  void printForms() {
    print("""
    EventName: $eventName
    EventDescription: $eventDesc
    EventLocation: $eventLocation
    EventDate: ${DateFormat.yMMMd().format(eventDateStart)}
    BeaconUUID: $beaconUUID 
    Major: $major
    Minor: $minor
    ImageURL: ${_image.path}
    """);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> orgMenu = [
      DropdownMenuItem(
        child: Text("CSD"),
        value: "csd",
      ),
      DropdownMenuItem(
        child: FlatButton(
            child: Text("Add New"),
            onPressed: () async => await showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      contentPadding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                      title: Text("Add Organization"),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Add"),
                        )
                      ],
                    ))),
        value: "add new",
      )
    ];
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _image != null
          ? FloatingActionButton.extended(
              backgroundColor: Colors.red[300],
              icon: Icon(Icons.create),
              label: Text("Create Event"),
              onPressed: () async {
                await showUploadTask().then((val) {
                  uploadFile(_image.path).then((val) async {
                    submitEvent();
                  }).whenComplete(() {
                    addEvent();
                  });
                });
              },
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 0.0,
        title: Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this.eventKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
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
                    decoration: InputDecoration(
                        labelText: "Event Description",
                        border: OutlineInputBorder()),
                    maxLines: 3,
                    onSaved: (str) {
                      eventDesc = str;
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
                          initialValue: "",
                          maxLength: 50,
                          decoration: InputDecoration(
                            labelText: "Event Location",
                          ),
                          onSaved: (str) {
                            eventLocation = str;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButton(
                            hint: Text("Select Organization"),
                            items: orgMenu,
                            onChanged: (val) {}),
                      )
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
                          maxLength: 35,
                          decoration: InputDecoration(
                              labelText: "Beacon UUID",
                              labelStyle: Theme.of(context).textTheme.body1),
                          onSaved: (str) => beaconUUID = str,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
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
                            maxLength: 4,
                            onSaved: (str) => minor = str,
                            decoration: InputDecoration(
                                labelText: "Minor",
                                labelStyle: Theme.of(context).textTheme.body1)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Upload Image"),
                    onPressed: getImage,
                    shape: StadiumBorder(),
                  ),
                ),
                _image == null
                    ? Center(child: Text("No file selected"))
                    : Column(children: [
                        AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: Image.file(
                            _image,
                          ),
                        ),
                      ]),
              ]),
        ),
      ),
    );
  }
}

//Pagination Page, Alternative to Stepper in Flutter.

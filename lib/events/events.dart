import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:final_parola/events/date_time.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';

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

  TextEditingController eventNameController,
      eventDescriptionController,
      beaconUUIDController,
      majorController,
      minorController;
  String eventName, eventDesc, beaconUUID, major, minor, eventLocation, _path;
  final GlobalKey<FormState> key = new GlobalKey<FormState>();
  File _image;
  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<Null> uploadFile(String filepath) async {
    final String fileName = '${new Random().nextInt(10000)}.jpg';
    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('eventImages/$fileName');
    final StorageUploadTask task = storageRef.putFile(file);
    
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();

    print(_path);
  }

  void showSnackBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Successfully Uploaded"),
      duration: Duration(seconds: 5),
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[300],
        icon: Icon(Icons.create),
        label: Text("Create Event"),
        onPressed: () async {
          await uploadFile(_image.path).then((e) => Flushbar(
                title: 'Successfully Uploaded',
              ));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this.key,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Event Name"),
                onSaved: (str) {
                  eventName = str;
                },
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
              child: TextFormField(
                initialValue: "",
                decoration: InputDecoration(
                  labelText: "Event Location",
                ),
                onSaved: (str) => eventLocation,
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
            RaisedButton(
              child: Text("Upload Image"),
              onPressed: getImage,
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

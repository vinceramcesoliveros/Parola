import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatelessWidget {
  final String username;
  UserProfile({this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.green[400],
        ),
        body: UserCard(
          username: username,
        ));
  }
}

class UserCard extends StatelessWidget {
  final String username;

  UserCard({
    this.username,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            child: StreamBuilder(
              stream: FirebaseAuth.instance.currentUser().asStream(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (!snapshot.hasData)
                  return Text("Loading...");
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                              imageUrl: snapshot.data.photoUrl),
                        ),
                      ),
                      Text(snapshot.data.displayName,
                          style: Theme.of(context).textTheme.display1),
                      EditProfile(),
                    ],
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Card(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('organization')
                    .where('owner', isEqualTo: username)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<DocumentSnapshot> orgSnapshot = snapshot.data.documents;
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return orgSnapshot.isEmpty
                      ? Text(
                          "No Organization",
                          style: Theme.of(context).textTheme.display1,
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              "Organization",
                              style: Theme.of(context).textTheme.display1,
                            ),
                            Text(
                              snapshot.data.documents[0].data['orgName']
                                  .toString(),
                              style: Theme.of(context).textTheme.title,
                            )
                          ],
                        );
                }),
          )
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<String> eventListName = List();
  TextEditingController firstNameController = new TextEditingController();

  TextEditingController lastNameController = new TextEditingController();

  TextEditingController middleNameController = new TextEditingController();
  @override
  void initState() {
    queryAllEvents();
    super.initState();
  }

  Future<Null> queryAllEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Firestore.instance
        .collection('events')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              Firestore.instance
                  .collection('${doc.documentID}_attendees')
                  .where('userid', isEqualTo: prefs.getString('userid'))
                  .snapshots()
                  .listen((eventData) {
                eventData.documents.forEach((eventDoc) {
                  eventListName.add(eventDoc['eventID']);
                  print(eventDoc['eventName']);
                });
                // eventListName.add(eventData.documents[0].data['eventName']);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.green[200],
        shape: StadiumBorder(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Text("Edit Name"), Icon(Icons.edit)],
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    title: Text("Edit Profile"),
                    children: <Widget>[
                      TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration.collapsed(
                              hintText: "First Name")),
                      TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration.collapsed(
                              hintText: "Middle Name")),
                      TextFormField(
                          controller: middleNameController,
                          decoration:
                              InputDecoration.collapsed(hintText: "Last Name")),
                      ButtonTheme.bar(
                          child: ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                              child: Text("Update"),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                UserUpdateInfo updateInfo = UserUpdateInfo();
                                updateInfo.displayName =
                                    "${firstNameController.text} ${middleNameController.text} ${lastNameController.text}";
                                prefs.setString('username',
                                    "${firstNameController.text} ${middleNameController.text} ${lastNameController.text}");
                                Map<String, dynamic> updateName = {
                                  "firstName": firstNameController.text,
                                  "lastName": lastNameController.text,
                                  "middleName": middleNameController.text
                                };
                                await FirebaseAuth.instance
                                    .updateProfile(updateInfo)
                                    .then((e) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(prefs.getString('userid'))
                                      .updateData(updateName);
                                  Firestore.instance
                                      .collection(
                                          'event_attended_${prefs.getString('username')}')
                                      .document(prefs.getString('userid'))
                                      .updateData(updateName);
                                  eventListName.forEach((doc) {
                                    Firestore.instance
                                        .collection(doc)
                                        .document(
                                            '${prefs.getString('userid')}')
                                        .updateData(updateName);
                                  });
                                }).whenComplete(() => Navigator.pop(context));
                              })
                        ],
                      ))
                    ],
                  ));
        });
  }
}

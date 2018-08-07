//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = FirebaseApp.instance;
  final config = FirebaseApp.configure(
      name: 'Parola',
      options: FirebaseOptions(
          projectID: 'parola-2468e',
          googleAppID: '1:818472414092:android:a9c5fa1888c6f112',
          apiKey: 'AIzaSyC5oO96yzVWTdgDZWG44GZ7kATMq603tSA'));
//   StreamSubscription _scanSubscription;

//   Beacons.loggingEnabled = true;
//  Beacons.configure(BeaconsSettings(
//      android: BeaconsSettingsAndroid(logs: BeaconsSettingsAndroidLogs.info),
//      iOS: BeaconsSettingsIOS()));
//  // _scanSubscription.cancel();
  @override
  @override
  void initState() {
    _storeUser();
    super.initState();
  }

  _storeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final DocumentReference userRef = Firestore.instance
        .collection("users")
        .document(prefs.getString("userid"));
    Map<String, String> userData = {
      "username": prefs.getString("username") ?? '',
      "email": prefs.getString("useremail") ?? '',
      "photoURL": prefs.getString("userphotoURL") ?? '',
    };

    ///Equivalent to
    ///Insert into users values (userID,email,photoURL)
    await userRef
        .setData(userData,
            merge: true) // Check if the userID has duplicate data
        .whenComplete(() => print("User added"))
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(FontAwesomeIcons.bluetoothB),
          onPressed: () {},
          label: Text("Join Event"),
          backgroundColor: Colors.red[800],
        ),
        backgroundColor: Colors.red[400],
        appBar: AppBar(
          title: CircleAvatar(
              child: SvgPicture.asset(
                'assets/lighthouse.svg',
                height: 32.0,
                width: 32.0,
              ),
              maxRadius: 32.0,
              backgroundColor: Colors.red[400]),
          elevation: 0.0,
          backgroundColor: Colors.red[400],
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              splashColor: Colors.red[400],
              icon: Icon(
                Icons.search,
                size: 32.0,
              ),
              onPressed: () {},
            )
          ],
        ),
        drawer: UserDrawer(),
        body: HBodyPage(),
      ),
    );
  }

  Future<bool> _onExit() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit Parola?"),
              content: Text("Do you want to exit Parola?"),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.red[200],
                  child: Text("Nope"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(child: Text("Yes"), onPressed: () => exit(0)),
              ],
            ));
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.currentUser().asStream(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        return UserAccountsDrawerHeader(
          accountName: Text(snapshot.data.displayName),
          accountEmail: Text(snapshot.data.email),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data.photoUrl),
          ),
          key: Key(snapshot.data.uid),
        );
      },
    );
  }
}

class UserDrawer extends StatefulWidget {
  @override
  UserDrawerState createState() {
    return new UserDrawerState();
  }
}

class UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    Future<Null> _signOutGoogle() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _signIn = new GoogleSignIn();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _signIn.signOut();
      await _auth.signOut();
      prefs.clear();
      // prefs.commit();
      this.setState(() {
        Navigator.of(context).pushNamed("/login");
        loggedIn = false;
      });
      print(loggedIn);
    }

    return Drawer(
      semanticLabel: "Open Settings",
      elevation: 0.0,
      child: ListView(
        children: <Widget>[
          UserProfile(),
          ListTile(
            title: Text("Exit"),
            leading: Icon(Icons.exit_to_app),
            onTap: () => _signOutGoogle(),
          ),
          AboutListTile()
        ],
      ),
    );
  }
}

class HBodyPage extends StatefulWidget {
  @override
  _HBodyPageState createState() => _HBodyPageState();
}

class _HBodyPageState extends State<HBodyPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return EventListView(
            eventDocuments: snapshot.data.documents,
          );
        });
  }
}

class EventListView extends StatelessWidget {
  final List<DocumentSnapshot> eventDocuments;

  const EventListView({Key key, this.eventDocuments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventDocuments.length,
      itemExtent: 60.0,
      itemBuilder: (context, index) {
        String eventTitle = eventDocuments[index].data['eventName'].toString();
        String eventDate = eventDocuments[index].data['eventDate'].toString();
        return ListTile(
          title: Text(eventTitle),
          subtitle: Text(eventDate),
        );
      },
    );
  }
}

//Add Bottom Navigation

import 'package:final_parola/home/about.dart';
import 'package:final_parola/home/eventBody.dart';
import 'package:final_parola/home/exit.dart';
import 'package:final_parola/login/login.dart';
import 'package:final_parola/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.longestSide / 3,
      child: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.currentUser().asStream(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (!snapshot.hasData) return Text("Loading...");
            return Drawer(
              semanticLabel: "Open Settings",
              elevation: 0.0,
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.green[400]),
                    accountName: Text(snapshot.data.displayName ?? ''),
                    accountEmail: Text(snapshot.data.email ?? ''),
                    currentAccountPicture: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: snapshot.data.photoUrl,
                        placeholder: CircularProgressIndicator(),
                      ),
                    ),
                    key: Key(snapshot.data.uid),
                  ),
                  ListTile(
                      title: Text("Read Tutorial"),
                      leading: Icon(Icons.inbox),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/introduction', ModalRoute.withName('/home'));
                      }),
                  ListTile(
                    title: Text("Events"),
                    leading: Icon(Icons.event_note),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      print(snapshot.data.uid);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventBodyPage(
                              userid: snapshot.data.uid ??
                                  prefs.getString('userid'))));
                    },
                  ),
                  ListTile(
                    title: Text("Edit Profile"),
                    leading: Icon(Icons.person),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      Navigator.of(context).pop();
                      snapshot.data.displayName == null
                          ? showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                        "You need to sign in again for verification"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Okay"),
                                        onPressed: () =>
                                            Navigator.pushReplacementNamed(
                                                context, '/login'),
                                      )
                                    ],
                                  ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        username: snapshot.data.displayName
                                      )));
                    },
                  ),
                  ExitParola(),
                  AboutParola(),
                ],
              ),
            );
          }),
    );
  }
}

import 'package:final_parola/home/about.dart';
import 'package:final_parola/home/exit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.currentUser().asStream(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.red[400]),
          accountName: Text(snapshot.data.displayName),
          accountEmail: Text(snapshot.data.email),
          currentAccountPicture: ClipOval(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: snapshot.data.photoUrl,
              placeholder: CircularProgressIndicator(),
            ),
          ),
          key: Key(snapshot.data.uid),
        );
      },
    );
  }
}

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.longestSide / 3,
      child: Drawer(
        semanticLabel: "Open Settings",
        elevation: 0.0,
        child: ListView(
          children: <Widget>[
            UserProfile(),
            ListTile(
                title: Text("Read Tutorial"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).popAndPushNamed('/introduction');
                }),
            ListTile(
              title: Text("Create Events"),
              leading: Icon(Icons.event_note),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/event');
              },
            ),
            ExitParola(),
            AboutParola(),
          ],
        ),
      ),
    );
  }
}

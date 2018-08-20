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
        return UserAccountsDrawerHeader(
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
    return Drawer(
      semanticLabel: "Open Settings",
      elevation: 0.0,
      child: ListView(
        children: <Widget>[
          UserProfile(),
          ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              onTap: () {}),
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
    );
  }
}

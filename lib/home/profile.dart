import 'package:final_parola/home/about.dart';
import 'package:final_parola/home/exit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
          ExitParola(),
          AboutParola(),
        ],
      ),
    );
  }
}
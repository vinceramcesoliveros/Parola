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
        body: ListView.builder(
          itemBuilder: (context, index) {
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: new UserCard(),
                ),
                Expanded(
                  flex: 4,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('attended_$username')
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<DocumentSnapshot> eventSnapshot =
                          snapshot.data.documents;
                      if (!snapshot.hasData)
                        return Center(child: Text('No events attended'));
                      return ListTile(
                          title:
                              Text(eventSnapshot[index].data[''].toString()));
                    },
                  ),
                )
              ],
            );
          },
        ));
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.currentUser().asStream(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: ClipOval(
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(imageUrl: snapshot.data.photoUrl),
                ),
              ),
              Text(snapshot.data.displayName,
                  style: Theme.of(context).textTheme.display1),
              EditProfile(),
            ],
          );
        },
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = new TextEditingController();
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
                          controller: nameController,
                          decoration:
                              InputDecoration.collapsed(hintText: "Name")),
                      ButtonTheme.bar(
                          child: ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                              child: Text("Update"),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                UserUpdateInfo updateInfo = UserUpdateInfo();
                                updateInfo.displayName = nameController.text;
                                prefs.setString(
                                    'username', nameController.text);
                                Map<String, dynamic> updateName = {
                                  "username": nameController.text
                                };
                                await FirebaseAuth.instance
                                    .updateProfile(updateInfo)
                                    .then((e) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(prefs.getString('userid'))
                                      .updateData(updateName);
                                }).whenComplete(() => Navigator.pop(context));
                              })
                        ],
                      ))
                    ],
                  ));
        });
  }
}

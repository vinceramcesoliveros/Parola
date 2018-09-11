import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0.0,
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Create Event"),
        icon: Icon(FontAwesomeIcons.plus),
        onPressed: () => Navigator.of(context).pushNamed('/event'),
      ),
      drawer: UserDrawer(),
      body: HomeBodyPage(),
    );
  }
}

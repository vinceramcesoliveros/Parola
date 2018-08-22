import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/profile.dart';
import 'package:flutter/material.dart';

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
      drawer: UserDrawer(),
      body: HomeBodyPage(),
    );
  }
}

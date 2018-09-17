import 'package:flutter/material.dart';

class UpcomingEvents extends StatelessWidget {
  final String user;
  UpcomingEvents({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("My Events"),
          centerTitle: true,
          backgroundColor: Colors.green[200]),
      body: UpcomingEventBody(),
    );
  }
}

class UpcomingEventBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {},
    );
  }
}

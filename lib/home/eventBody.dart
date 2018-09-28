import 'package:final_parola/admin/eventAdmin.dart';
import 'package:final_parola/events/attended_events.dart';
import 'package:final_parola/events/upcoming_events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventBodyPage extends StatelessWidget {
  final String userid;
  EventBodyPage({this.userid});
  final Radius kBorderRadius = Radius.circular(32.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[200],
          centerTitle: true,
          title: Text("Events")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4.0,
              color: Colors.green[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.shortestSide / 4,
                      width: MediaQuery.of(context).size.longestSide,
                      child: Text(
                        "Created Events",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ]),
                  ButtonTheme.bar(
                      child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 12.0,
                        shape: StadiumBorder(),
                        color: Colors.green[200],
                        child: Text(
                          "View Created Events",
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminEvents(
                                        userid: userid,
                                      )));
                        },
                      )
                    ],
                  ))
                ],
              ),
            ),
            Card(
              elevation: 4.0,
              color: Colors.red[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.shortestSide / 4,
                      width: MediaQuery.of(context).size.longestSide,
                      child: Text(
                        "Attended Events",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ]),
                  ButtonTheme.bar(
                      child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                          elevation: 12.0,
                          shape: StadiumBorder(),
                          color: Colors.green[200],
                          highlightColor: Colors.red[200],
                          child: Text(
                            "View Attended Events",
                            style: Theme.of(context).textTheme.title,
                          ),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AttendedEvents(user: userid)));
                          }),
                    ],
                  ))
                ],
              ),
            ),
            Card(
              elevation: 4.0,
              color: Colors.grey[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.shortestSide / 4,
                      width: MediaQuery.of(context).size.longestSide,
                      child: Text(
                        "Upcoming Events",
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                  ]),
                  ButtonTheme.bar(
                      child: ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 12.0,
                        shape: StadiumBorder(),
                        color: Colors.green[200],
                        child: Text(
                          "View Upcoming Events",
                          style: Theme.of(context).textTheme.title,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UpcomingEvents(user: userid)));
                        },
                      )
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

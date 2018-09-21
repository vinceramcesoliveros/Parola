import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/description.dart';
import 'package:final_parola/home/eventBody.dart';
import 'package:final_parola/home/profile.dart';
import 'package:final_parola/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScaffold extends StatefulWidget {
  @override
  MyScaffoldState createState() {
    return new MyScaffoldState();
  }
}

class MyScaffoldState extends State<MyScaffold> {
  // PopupMenuButton(
  //     itemBuilder: (context) => [
  //           PopupMenuItem(
  //             value: "eventDate",
  //             child: Text("Sort by Date"),
  //           ),
  //           PopupMenuItem(
  //               value: "eventName", child: Text("Sort by Name")),
  //           PopupMenuItem(
  //               value: "eventLocation", child: Text("Sort by Location"))
  //         ])

  HomeBodyPage homeBodyPage;
  EventBodyPage eventBodyPage;
  List<Widget> pages;
  List<String> eventLists = new List();
  Widget currentPage;
  int currentIndex = 0;
  String username;
  @override
  void initState() {
    homeBodyPage = HomeBodyPage();
    eventBodyPage = EventBodyPage();
    pages = [homeBodyPage, eventBodyPage];
    currentPage = homeBodyPage;
    queryEvents();
    super.initState();
  }

  Future<Null> queryEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    Firestore.instance.collection('events').snapshots().listen((data) =>
        data.documents.forEach((doc) => eventLists.add(doc["eventName"])));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<EventModel>(
      model: EventModel(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[200],
        appBar: AppBar(
          brightness: Brightness.light,
          title: currentIndex == 0 ? Text("Home") : Text("Events"),
          elevation: 4.0,
          backgroundColor: Colors.green[300],
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: EventSearchQuery(
                        eventLists: eventLists, username: username));
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red[200],
          label: Text("Create Event"),
          icon: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushNamed('/event'),
        ),
        floatingActionButtonLocation: currentIndex == 0
            ? FloatingActionButtonLocation.centerDocked
            : FloatingActionButtonLocation.endFloat,
        drawer: UserDrawer(),
        body: currentPage,
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 32.0,
          fixedColor: Colors.green[700],
          currentIndex: currentIndex,
          onTap: (current) {
            setState(() {
              currentIndex = current;
              currentPage = pages[current];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_available), title: Text("Events"))
          ],
        ),
      ),
    );
  }
}

class EventSearchQuery extends SearchDelegate<String> {
  final List<String> eventLists;
  final String username;
  EventSearchQuery({this.eventLists, this.username});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return DescBody(
      eventTitle: query,
      username: username,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchQuery = eventLists.isEmpty
        ? eventLists
        : eventLists.where((p) => p.startsWith(query)).toSet().toList();
    return eventLists == null
        ? ListTile(
            title: Text("Loading..."),
          )
        : ListView.builder(
            itemCount: searchQuery.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  query = searchQuery[0];
                  showResults(context);
                },
                title: RichText(
                    text: TextSpan(
                        text: searchQuery[index].substring(0, query.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: searchQuery[index].substring(query.length),
                          style: TextStyle(color: Colors.white70))
                    ])),
                leading: Icon(Icons.event),
              );
            },
          );
  }
}

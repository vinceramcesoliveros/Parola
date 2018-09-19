import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/eventBody.dart';
import 'package:final_parola/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class MyScaffold extends StatefulWidget {
  @override
  MyScaffoldState createState() {
    return new MyScaffoldState();
  }
}

class MyScaffoldState extends State<MyScaffold> {
  SearchBar searchBar;
  MyScaffoldState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: searchAppBar,
        setState: setState,
        onSubmitted: (val) => querySearch(val));
  }
  querySearch(String query) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(title: Text(query)));
  }

  AppBar searchAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,
      title: currentIndex == 0 ? Text("Home") : Text("Events"),
      elevation: 4.0,
      backgroundColor: Colors.green[300],
      centerTitle: true,
      actions: <Widget>[
        searchBar.getSearchAction(context),
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "eventDate",
                    child: Text("Sort by Date"),
                  ),
                  PopupMenuItem(
                      value: "eventName", child: Text("Sort by Name")),
                  PopupMenuItem(
                      value: "eventLocation", child: Text("Sort by Location"))
                ])
      ],
    );
  }

  HomeBodyPage homeBodyPage;
  EventBodyPage eventBodyPage;
  List<Widget> pages;
  Widget currentPage;
  int currentIndex = 0;
  @override
  void initState() {
    homeBodyPage = HomeBodyPage();
    eventBodyPage = EventBodyPage();
    pages = [homeBodyPage, eventBodyPage];

    currentPage = homeBodyPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.green[200],
      appBar: searchBar.build(context),
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
    );
  }
}

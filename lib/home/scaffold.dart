import 'package:final_parola/home/body.dart';
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
        buildDefaultAppBar: searchAppBar,
        setState: setState,
        onSubmitted: null);
  }
  AppBar searchAppBar(BuildContext context) {
    return AppBar(
      title: Text("Home"),
      elevation: 0.0,
      backgroundColor: Colors.green[300],
      centerTitle: true,
      actions: <Widget>[searchBar.getSearchAction(context)],
    );
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
        icon: Icon(FontAwesomeIcons.plus),
        onPressed: () => Navigator.of(context).pushNamed('/event'),
      ),
      drawer: UserDrawer(),
      body: HomeBodyPage(),
    );
  }
}

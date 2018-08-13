import 'package:final_parola/home/body.dart';
import 'package:final_parola/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(FontAwesomeIcons.bluetoothB),
        onPressed: () {},
        label: Text("Join Event"),
        backgroundColor: Colors.red[800],
      ),
      backgroundColor: Colors.red[400],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                child: SvgPicture.asset(
                  'assets/lighthouse.svg',
                  height: 32.0,
                  width: 32.0,
                ),
                maxRadius: 32.0,
                backgroundColor: Colors.red[400]),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.red[400],
        centerTitle: true,
        actions: <Widget>[
          Icon(
            Icons.add,
            size: 32.0,
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: HomeBodyPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutParola extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: Icon(FontAwesomeIcons.info),
      applicationName: 'Parola',
      applicationVersion: 'v0.2',
      applicationLegalese: 'Developer: Vince Ramces Oliveros',
      child: Text("About Parola"),
      aboutBoxChildren: <Widget>[
        Text(
          '''This will be implemented in the next few weeks more!!''',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}

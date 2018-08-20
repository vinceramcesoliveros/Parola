import 'package:final_parola/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class ExitParola extends StatefulWidget {
  @override
  _ExitParolaState createState() => _ExitParolaState();
}

class _ExitParolaState extends State<ExitParola> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      rebuildOnChange: false,
      builder: (context, child, model) => ListTile(
            title: Text("Exit"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              model.signOut().then((e) => Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", ModalRoute.withName("/")));
            },
          ),
    );
  }
}

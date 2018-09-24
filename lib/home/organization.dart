import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrganizationLists extends StatefulWidget {
  final String userid;
  OrganizationLists({this.userid});
  @override
  OrganizationListsState createState() {
    return new OrganizationListsState();
  }
}

class OrganizationListsState extends State<OrganizationLists> {
  GlobalKey<FormState> _organizationKey = GlobalKey<FormState>();

  TextEditingController orgNameController = TextEditingController();

  TextEditingController orgDescController = TextEditingController();
  String orgName, orgDesc;
  Map<String, String> setOrganizer = Map();
  final orgQuery = Firestore.instance.collection('organization').document();
  void addOrgForm() async {
    final formKey = _organizationKey.currentState;
    if (formKey.validate()) {
      formKey.save();
      setOrganization().whenComplete(() {
        Fluttertoast.showToast(msg: "Added Organization");
        Navigator.pop(context);
      });
    }
  }

  Future<Null> setOrganization() async {
    setOrganizer = {
      "owner": widget.userid,
      "OrgName": orgName,
      "OrgDescription": orgDesc
    };
    Firestore.instance.batch().setData(orgQuery, setOrganizer);
    print("Added Organization");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: this._organizationKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextFormField(
              controller: orgNameController,
              decoration: InputDecoration(hintText: "Organization Name"),
              validator: (val) => val.isEmpty ? 'required' : null,
              onSaved: (val) => orgName = val,
            ),
            TextFormField(
              controller: orgDescController,
              decoration: InputDecoration(hintText: "Description"),
              onSaved: (val) => orgDesc,
            ),
            RaisedButton(
                onPressed: () async {
                  addOrgForm();
                },
                child: Text("Add Organization"),
                shape: StadiumBorder())
          ]),
        ),
      ),
    );
  }
}

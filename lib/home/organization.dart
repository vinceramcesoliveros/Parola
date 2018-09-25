import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrganization extends StatefulWidget {
  final String userid;
  AddOrganization({this.userid});
  @override
  OrganizationListsState createState() {
    return new OrganizationListsState();
  }
}

class OrganizationListsState extends State<AddOrganization> {
  GlobalKey<FormState> _organizationKey = GlobalKey<FormState>();
  String orgName, orgDesc;

  final orgQuery = Firestore.instance.collection('organization').document();
  Future<Null> setOrganization() async {}

  @override
  Widget build(BuildContext context) {
    void addOrgForm() {
      final formKey = _organizationKey.currentState;
      if (formKey.validate()) {
        formKey.save();
        Map<String, String> setOrganizer = {
          "userid": widget.userid,
          ""
          "OrgName": orgName,
          "OrgDescription": orgDesc
        };

        setOrganization().then((e) {
          orgQuery.setData(setOrganizer);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        centerTitle: true,
        title: Text("Create Organization"),
      ),
      body: Form(
        key: this._organizationKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Organization Name"),
              validator: (val) => val.isEmpty ? 'required' : null,
              onSaved: (val) => orgName = val,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Description"),
              onSaved: (val) => orgDesc = val,
            ),
            RaisedButton(
                onPressed: addOrgForm,
                child: Text("Add Organization"),
                shape: StadiumBorder())
          ]),
        ),
      ),
    );
  }
}

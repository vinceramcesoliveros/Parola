import 'package:flutter/material.dart';

class AttendedEvents extends StatelessWidget {
  final String user;
  AttendedEvents({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attended Events"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: AttendedEventBody(),
    );
  }
}

class AttendedEventBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context,snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemBuilder: (context,index){
            
          },
        );
      },
    );
  }
}

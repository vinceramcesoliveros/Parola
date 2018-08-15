import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DescPage extends StatelessWidget {
  final String eventTitle;

  DescPage({this.eventTitle});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text(eventTitle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.event),
          label: Text("Attend Event"),
          onPressed: () {
            Navigator.of(context).pushNamed('/attend');
          }),
      body: DescBody(
        eventTitle: eventTitle,
      ),
    );
  }
}

class DescBody extends StatelessWidget {
  final String eventTitle;

  DescBody({this.eventTitle});

  @override
  Widget build(BuildContext context) {
    final descQuery = Firestore.instance
        .collection('events')
        .where('eventName', isEqualTo: eventTitle)
        .snapshots();
    return StreamBuilder(
      stream: descQuery,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return DescListView(
          descDocuments: snapshot.data.documents,
        );
      },
    );
  }
}

class DescListView extends StatelessWidget {
  final List<DocumentSnapshot> descDocuments;
  DescListView({this.descDocuments});
  @override
  Widget build(BuildContext context) {
    double phoneSize = MediaQuery.of(context).size.shortestSide;
    return ListView.builder(
      itemExtent: phoneSize * 2,
      itemCount: descDocuments.length,
      itemBuilder: (context, index) {
        String eventPic = descDocuments[index].data['eventPicURL'].toString();
        String eventDesc = descDocuments[index].data['eventDesc'].toString();
        //TODO: Add Beacon UUID, Major, Minor. or maybe it will be directed to a new
        // Page that will have access to Beacon UUID, Major and Minor values too!
        return Column(
          children: <Widget>[
            CachedNetworkImage(
              height: phoneSize,
              width: phoneSize,
              imageUrl: eventPic,
              placeholder: CircularProgressIndicator(),
            ),
            Center(
              child: Text(
                eventDesc,
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ],
        );
      },
    );
  }
}

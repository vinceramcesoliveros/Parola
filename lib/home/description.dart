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
    return ListView.builder(
      itemExtent: 700.0,
      itemCount: descDocuments.length,
      itemBuilder: (context, index) {
        String eventPic = descDocuments[index].data['eventPicURL'].toString();
        String eventDesc = descDocuments[index].data['eventDesc'].toString();
        return Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: eventPic,
              placeholder: CircularProgressIndicator(),
            ),
            Center(
              child: Text(eventDesc),
            ),
          ],
        );
      },
    );
  }
}

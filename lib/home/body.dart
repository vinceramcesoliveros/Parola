import 'package:final_parola/home/description.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('events')
            .orderBy('timeStart', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData)
            return SpinKitThreeBounce(color: Colors.green[200]);
          return EventListView(
            eventDocuments: snapshot.data.documents,
          );
        });
  }
}

class EventListView extends StatelessWidget {
  final List<DocumentSnapshot> eventDocuments;

  const EventListView({Key key, this.eventDocuments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventDocuments.length,
      itemBuilder: (context, index) {
        List<DocumentSnapshot> snapshot = eventDocuments;
        String eventTitle = snapshot[index].data['eventName'].toString();
        DateTime eventDate = snapshot[index].data['eventDate'];
        String eventPic = snapshot[index].data['eventPicURL'].toString();
        return Card(
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
          elevation: 16.0,
          child: GestureDetector(
            child: ListTile(
              title: Text(snapshot[index].data['eventName'].toString()),
              subtitle: Text(DateFormat.yMMMd().format(eventDate)),
              leading: new EventImage(eventPic: eventPic),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String username = prefs.getString('username');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => DescPage(
                              eventTitle:
                                  snapshot[index].data['eventName'].toString(),
                              username: username,
                            )),
                    (p) => true);
              },
            ),
          ),
        );
      },
    );
  }
}

class EventImage extends StatelessWidget {
  const EventImage({
    Key key,
    @required this.eventPic,
  }) : super(key: key);

  final String eventPic;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 32.0,
      backgroundColor: Colors.green[300],
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CachedNetworkImage(
          imageUrl: eventPic,
          placeholder: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

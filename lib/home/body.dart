import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return EventListView(
            eventDocuments: snapshot.data.documents,
          );
        });
  }
}

//FIXME: Trying to make the list of events more look than this. will try to
// put Firebase Storage too as a storage of calling images.
class EventListView extends StatelessWidget {
  final List<DocumentSnapshot> eventDocuments;

  const EventListView({Key key, this.eventDocuments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventDocuments.length,
      itemExtent: 90.0,
      itemBuilder: (context, index) {
        String eventTitle = eventDocuments[index].data['eventName'].toString();
        String eventDate = eventDocuments[index].data['eventDate'].toString();
        String eventPic = eventDocuments[index].data['eventPicURL'].toString();
        return Card(
          child: ListTile(
            title: Text(eventTitle),
            subtitle: Text(eventDate),
            leading: Image.network(
              eventPic,
              repeat: ImageRepeat.noRepeat,
              fit: BoxFit.cover,
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}

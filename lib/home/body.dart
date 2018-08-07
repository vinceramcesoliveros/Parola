import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.red[200],
            ));
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
      itemExtent: 60.0,
      itemBuilder: (context, index) {
        String eventTitle = eventDocuments[index].data['eventName'].toString();
        String eventDate = eventDocuments[index].data['eventDate'].toString();
        return ListTile(
          onTap: () {},
          title: Text(eventTitle),
          subtitle: Text(eventDate),
          leading: Icon(Icons.event_available),
        );
      },
    );
  }
}

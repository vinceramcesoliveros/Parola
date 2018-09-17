import 'package:final_parola/home/description.dart';
import 'package:final_parola/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<EventModel>(
      model: EventModel(),
      child: ScopedModelDescendant<EventModel>(
        builder: (context, child, model) => StreamBuilder(
            stream: model.events,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return SpinKitThreeBounce(color: Colors.green[200]);
              return EventListView(
                eventDocuments: snapshot.data.documents,
              );
            }),
      ),
    );
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
      itemExtent: MediaQuery.of(context).size.height / 10,
      itemCount: eventDocuments.length,
      itemBuilder: (context, index) {
        String eventTitle = eventDocuments[index].data['eventName'].toString();
        String eventDate = eventDocuments[index].data['eventDate'].toString();
        String eventPic = eventDocuments[index].data['eventPicURL'].toString();
        String eventKey = eventDocuments[index].documentID.toString();
        return Card(
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
          elevation: 16.0,
          child: GestureDetector(
            child: ListTile(
              title: Text(eventTitle),
              subtitle: Text(eventDate),
              leading: CircleAvatar(
                maxRadius: 32.0,
                backgroundColor: Colors.green[300],
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: eventPic,
                  ),
                ),
              ),
              onTap: () {
                //FIXME: When we tap to this index, we want to display the info about the event.
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => DescPage(
                              eventKey: eventKey,
                              eventTitle: eventTitle,
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

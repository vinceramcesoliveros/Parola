import 'package:final_parola/home/description.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventQuery = Firestore.instance.collection('events').snapshots();
    return StreamBuilder(
        stream: eventQuery,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor: Colors.red[200],
            );
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
  final eventQuery;

  const EventListView({Key key, this.eventDocuments, this.eventQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double phoneSize = MediaQuery.of(context).size.shortestSide;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Pinned",
            style: Theme.of(context).textTheme.title,
          ),
          
          Divider(
            height: 16.0,
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: eventDocuments.length,
              itemExtent: 90.0,
              itemBuilder: (context, index) {
                String eventTitle =
                    eventDocuments[index].data['eventName'].toString();
                String eventDate =
                    eventDocuments[index].data['eventDate'].toString();
                String eventPic =
                    eventDocuments[index].data['eventPicURL'].toString();
                return Card(
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(eventTitle),
                      subtitle: Text(eventDate),
                      leading: CachedNetworkImage(
                        height: phoneSize / 2,
                        imageUrl: eventPic,
                      ),
                      onTap: () {
                        //FIXME: When we tap to this index, we want to display the info about the event.
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => DescPage(
                                      eventTitle: eventTitle,
                                    )),
                            (p) => true);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ]);
  }
}

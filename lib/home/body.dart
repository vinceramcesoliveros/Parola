import 'package:final_parola/home/description.dart';
import 'package:final_parola/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData == null && !snapshot.hasData)
            return SpinKitThreeBounce(color: Colors.green[200]);
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
      itemBuilder: (context, index) {
        String eventTitle = eventDocuments[index].data['eventName'].toString();
        DateTime eventDate = eventDocuments[index].data['eventDate'];
        String eventPic = eventDocuments[index].data['eventPicURL'].toString();
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
              subtitle: Text("${DateFormat.yMMMd().format(eventDate)}"),
              leading: new EventImage(eventPic: eventPic),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String username = prefs.getString('username');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => DescPage(
                              eventTitle: eventTitle,
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
        ),
      ),
    );
  }
}

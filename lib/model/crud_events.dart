import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';

class ParolaFirebase extends Model {
  Future<void> deleteEvents({String eventKey, String eventName}) async {
    StorageReference deleteRef =
        FirebaseStorage.instance.ref().child("eventImages/$eventKey.jpg");
    final eventKeyAttendees = Firestore.instance
        .collection('${eventKey.toString()}_attendees')
        .snapshots();
    final eventAttendees =
        Firestore.instance.collection('${eventKey.toString()}_attendees');
    final eventKeys =
        Firestore.instance.collection('events').document('$eventKey');

    await deleteRef.delete().then((del) {
      print("Deleted: $eventKey");
    }).whenComplete(() {
      eventKeyAttendees.listen((data) async {
        data.documents.forEach((documents) {
          return eventAttendees
              .document(documents.documentID)
              .delete()
              .then((doc) {
            print("Deleted $eventKey");
            eventKeys.delete().then((doc) {
              print('Deleted $eventKey from events');
            });
          });
        });
      });
    });

    notifyListeners();
  }
}

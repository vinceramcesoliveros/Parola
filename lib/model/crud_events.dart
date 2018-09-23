import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';

class ParolaFirebase extends Model {
  Future<void> deleteEvents({String eventKey, String eventName}) async {
    StorageReference deleteRef =
        FirebaseStorage.instance.ref().child("eventImages/$eventKey.jpg");
    Firestore.instance.enablePersistence(true);
    await deleteRef.delete().then((del) {
      print("Deleted: $eventKey");
    });
    Firestore.instance
        .collection('events')
        .document('$eventKey')
        .delete()
        .then((doc) {
      print('Deleted $eventName');
    }).whenComplete(() {
      Firestore.instance
          .collection('${eventKey}_attendees')
          .document()
          .delete()
          .then((doc) {
        print("Deleted");
      });
    });
    notifyListeners();
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model {
  final eventQuery = Firestore.instance
      .collection('events')
      .orderBy('timeStart', descending: true)
      .snapshots();

  Stream<QuerySnapshot> get events => eventQuery;

  void getEvents() {}
}

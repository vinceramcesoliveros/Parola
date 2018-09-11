import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel extends Model {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future showNotification() async {
    AndroidNotificationDetails androidNotification = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    IOSNotificationDetails iosNotification = IOSNotificationDetails();
    NotificationDetails notifDetails =
        NotificationDetails(androidNotification, iosNotification);
    await localNotificationsPlugin.show(
        0, "Notification Example", 'Just a description', notifDetails,
        payload: 'items');

    notifyListeners();
  }
  Future eventNotification() async{
    
  }
}

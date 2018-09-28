// # Parola
// ### An event based attendance using Beacon Technology

//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!
// UPDATE: I've organized my widgets to separate dart files
// so that you can find where and what is this
// doing. **OPEN THIS PROJECT IN AN EDITOR TO FIND THE PATH WHAT YOU ARE LOOKING FOR**.
// I did this because I want to make a rule **"100 lines of code per file"**.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_parola/admin/eventAdmin.dart';
import 'package:final_parola/home/create_event_tutorial.dart';

import 'package:final_parola/home/home.dart';
import 'package:final_parola/home/introduction.dart';
import 'package:final_parola/home/scaffold.dart';
import 'package:final_parola/login/login.dart';
import 'package:final_parola/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:final_parola/events/events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery/battery.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ParolaScreen());
  });
}

class ParolaScreen extends StatefulWidget {
  @override
  ParolaScreenState createState() {
    return new ParolaScreenState();
  }
}

///
///Checks if the `user` has signed in after closing
///the application
class ParolaScreenState extends State<ParolaScreen> {
  Battery battery = new Battery();
  int batteryLevel = 0;
  Color parolaColor = Colors.green[400];
  Color btnParola = Colors.green[400];
  Color cardColor = Colors.green[300];
  bool isLoggedIn = false;

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<bool> loggedIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _auth.onAuthStateChanged.firstWhere((user) => isLoggedIn = user != null);

      if (prefs.getString('username') != null) {
        isLoggedIn = true;
        print("Shared Prefs: " + prefs.getString('username'));
      } else {
        isLoggedIn = false;
      }
    });

    return isLoggedIn;
  }

  Future<int> currentBattery() async {
    batteryLevel = await battery.batteryLevel;

    return batteryLevel;
  }

  Future<void> initNotification() async {
    AndroidInitializationSettings initializeSettingAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    InitializationSettings settings = InitializationSettings(
        initializeSettingAndroid, iosInitializationSettings);
    localNotificationsPlugin.initialize(settings,
        selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("notification payload:" + payload);
    }
  }

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
  }

  Future cancelNotification() async {
    await localNotificationsPlugin.cancel(0);
  }

  @override
  void initState() {
    this.currentBattery();
    this.loggedIn();
    super.initState();
    initNotification();
    // showNotification();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(isLoggedIn: isLoggedIn, batteryLevel: batteryLevel),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
            display4: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[200],
          buttonColor: btnParola,
          cardColor: cardColor,
          scaffoldBackgroundColor: parolaColor,
        ),
        title: 'Parola',
        debugShowCheckedModeBanner: false,
        home: ScopedModelDescendant<UserModel>(
          rebuildOnChange: false,
          builder: (context, child, model) {
            return SplashScreen(
              title: Text(
                "Parola",
                style: Theme.of(context).textTheme.display4,
              ),
              image: Image.asset('assets/lighthouse_app.png'),
              backgroundColor: Colors.green[500],
              styleTextUnderTheLoader: TextStyle(),
              photoSize: MediaQuery.of(context).size.shortestSide / 4,
              onClick: () => print("Welcome to Parola"),
              loaderColor: Colors.green[200],
              seconds: 2,
              navigateAfterSeconds: isLoggedIn ? HomePage() : LoginPage(),
            );
          },
        ),
        // initialRoute: "/login",
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/event': (context) => EventPage(),
          '/homePage': (context) => MyScaffold(),
          '/introduction': (context) => IntroductionPage(),
          '/admin': (context) => AdminEvents(),
          '/event_tutorial': (context) => EventTutorial()
        },
      ),
    );
  }
}

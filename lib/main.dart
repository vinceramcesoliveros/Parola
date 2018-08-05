//If you're reading this code, please do not say that this is a spaghetti code since
// since I'm the one who wrote this, I've been refactoring it very well especially
// on private variable namings in dart.
// On the side note. Don't hesitate to ask the "WTF does this do??"
// I'm glad to hear feedbacks from you!!

import 'dart:async';

import 'package:final_parola/home.dart';
import 'package:flutter/material.dart';
// import 'package:beacons/beacons.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:scoped_model/scoped_model.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_parola/events.dart';

void main() {
  runApp(SplashScreen());
}

bool loggedIn = false;

///This class will save the User's
///information to access the homepage
///

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  ///
  ///Checkes if the [user] has signed in after closing
  ///the application
  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    this.setState(() {
      if (prefs.getString("username") != null) {
        loggedIn = true;
        print(prefs.getString('username'));
      } else {
        loggedIn = false;
      }
    });
    return loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      theme: ThemeData(),
      title: 'Parola',
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      home: loggedIn == true ? HomePage() : LoginPage(),
      // initialRoute: "/login",
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/event': (context) => EventPage(),
      },
    );
  }

  @override
  void initState() {
      this._isLoggedIn();

    super.initState();
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PBodyPage(),
    );
  }
}

class PBodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<PBodyPage> {
  Permission permission = Permission.AccessCoarseLocation;
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Container(
        color: Colors.red[400],
        child: Column(
          children: <Widget>[
            ParolaIcon(),
            Text("Parola", style: Theme.of(context).textTheme.display4),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  BtnGoogleSignIn(),
                  BtnFBSignIn(),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}

class BtnFBSignIn extends StatefulWidget {
  @override
  _BtnFBSignInState createState() => _BtnFBSignInState();
}

class _BtnFBSignInState extends State<BtnFBSignIn> {
  ///Facebook Sign in Authentication
  ///TODO:
  Future<FirebaseUser> _facebookSignIn() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        textColor: Colors.white,
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.facebookF,
              size: 16.0,
            ),
            Text(" | ", style: TextStyle(fontSize: 16.0)),
            Text("Sign in with Facebook"),
          ],
        ),
        color: Colors.blue[700],
        onPressed: () {
          _facebookSignIn();
        });
  }
}

class BtnGoogleSignIn extends StatefulWidget {
  @override
  _BtnGoogleSignInState createState() => _BtnGoogleSignInState();
}

class _BtnGoogleSignInState extends State<BtnGoogleSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = new GoogleSignIn();

  ///Automatically Sign in from Splash Screen,
  ///[Google Sign in API]
  Future<FirebaseUser> googleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await _signIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();

    prefs.setString("username", user.displayName);
    prefs.setString("userid", user.uid);
    prefs.setString("useremail", user.email);
    prefs.setString("userphotoURL", user.photoUrl);
    loggedIn = true;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.red[500],
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.google, size: 16.0),
          Text(" | ", style: TextStyle(fontSize: 16.0)),
          Text("Sign in with Google"),
        ],
      ),
      onPressed: () async {
        await googleSignIn().then(
            (FirebaseUser user) => Navigator.of(context).pushNamed('/home'));
      },
    );
  }
}

class ParolaIcon extends StatelessWidget {
  static String lightHouse = 'assets/lighthouse.svg';
  static Widget svg = SvgPicture.asset(
    lightHouse,
    color: Colors.red[400],
    height: 128.0,
    width: 104.0,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 64.0),
          child: CircleAvatar(
            maxRadius: 64.0,
            backgroundColor: Colors.deepPurpleAccent[200],
            foregroundColor: Colors.deepOrange[300],
            child: svg,
          ),
        ),
      ],
    );
  }
}
//     return Column(
//       children: <Widget>[
//         FloatingActionButton(
//           elevation: 2.0,
//           child: Icon(Icons.bluetooth),
//           onPressed: () {
//             setState(() {
//               _btOn();
//             });
//           },
//         )
//       ],
//     );
//   }

//   _btOn() {
//      showDialog(
//        context: context,
//        builder: (context)=>
//        AlertDialog(
//       actions: <Widget>[],
//       title: Text("Bluetooth on"),
//       content: Column(
//         children: <Widget>[
//           Text(
//             "Turn Bluetooth on",
//             style: Theme.of(context).textTheme.display1,
//           ),
//           ButtonBar(
//             children: <Widget>[
//               FlatButton(
//                 child: Text(
//                   "CANCEL",
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               RaisedButton(
//                   child: Text(
//                     "Turn on",
//                   ),
//                   onPressed: () {
//                     _onStart();
//                   })
//             ],
//           )
//         ],
//       ),
//     ));

//   }

//   void _onStart() {
//     FlutterBlue flutterBlue = FlutterBlue.instance;
//     final scanSubscription = flutterBlue
//         .scan(
//             scanMode: ScanMode.balanced, timeout: Duration(milliseconds: 3000))
//         .listen((result) {
//       print("Bluetooth Start Scanning: $result");
//     });
//     scanSubscription.cancel();
//   }
// }

// class BeaconRanging extends Model {
//   final beacon = Beacons
//       .ranging(
//         region: BeaconRegionIBeacon(
//           identifier: "test",
//           proximityUUID: "",
//         ),
//         permission: LocationPermission(
//             android: LocationPermissionAndroid.coarse,
//             ios: LocationPermissionIOS.whenInUse),
//         inBackground: false,
//       )
//       .listen((result) {});
//   // void _startConnect() {
//   //   beacon.cancel();
//   //   notifyListeners();
//   // }
// }

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

void main() {
  runApp(SplashScreen());
}

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn signIn = new GoogleSignIn();
bool loggedIn = false;

///[Google Sign in API]
Future<FirebaseUser> googleSignIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final GoogleSignInAccount googleUser = await signIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await auth.currentUser();
//    SaveUser(
//        username: user.displayName,
//        useremail: user.email,
//        userid: user.uid,
//        userphotoURL: user.photoUrl);
  prefs.setString("username", user.displayName);
  prefs.setString("userid", user.uid);
  prefs.setString("useremail", user.email);
  prefs.setString("userphotoURL", user.photoUrl);
  loggedIn = true;
  return currentUser;
}

///This class will save the User's
///information to access the homepage
//class SaveUser {
//  String username, useremail, userid, userphotoURL;
//  SaveUser({this.username, this.useremail, this.userid, this.userphotoURL});
//
//  Future<Null> saveUser() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setString("user", this.username);
//    prefs.setString("useremail", this.useremail);
//    prefs.setString("userid", this.userid);
//    prefs.setString("userphotoURL", this.userphotoURL);
//  }
//}

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
  Future<Null> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: 'Parola',
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      home: HomePage(), //loggedIn == true ? HomePage() : LoginPage(),
      initialRoute: "/login",
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }

  @override
  void initState() {
    this._isLoggedIn();

    // TODO: implement initState
    super.initState();
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PBodyPage(),
    );
  }
}

class PBodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<PBodyPage> {
  ///Facebook Sign in Authentication
  Future<FirebaseUser> _facebookSignIn() async {
    return null;
  }

  ///Automatically Sign in from Splash Screen, this is unnecessary to our code
  ///since We have a button to sign in through Google.
//  @override
//  void initSate() {
//    super.initState();
//    _auth.onAuthStateChanged.firstWhere((user) => user != null).then(
//        (user) => Navigator.of(context).pushReplacementNamed('/homePage'));
//    new Future.delayed(Duration(seconds: 1)).then((_) => _googleSignIn());
//  }
  static String lightHouse = 'assets/lighthouse.svg';
  static Widget svg = SvgPicture.asset(
    lightHouse,
    color: Colors.red[400],
    height: 128.0,
    width: 104.0,
  );
  Widget parolaIcon = Stack(
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
  Widget line = Text("|", style: TextStyle(fontSize: 16.0));
  Permission permission = Permission.AccessCoarseLocation;
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Container(
        color: Colors.red[400],
        child: Column(
          children: <Widget>[
            parolaIcon,
            Text("Parola", style: Theme.of(context).textTheme.display4),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.red[500],
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.google),
                        line,
                        Text("Sign in with Google"),
                      ],
                    ),
                    onPressed: () {
                      googleSignIn().then((FirebaseUser user) =>
                          Navigator.of(context).pushReplacementNamed('/home'));
                    },
                  ),
                  RaisedButton(
                      textColor: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.facebookF),
                          line,
                          Text("Sign in with Facebook"),
                        ],
                      ),
                      color: Colors.blue[700],
                      onPressed: () {
                        _facebookSignIn();
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
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

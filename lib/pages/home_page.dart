import 'package:easy_go/utilities/auth.dart';
import 'package:easy_go/utilities/firebase.dart';
import 'package:easy_go/utilities/get_current_location.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:cool_alert/cool_alert.dart';

class HomePageWithLogin extends StatefulWidget {
  @override
  _HomePageWithLoginState createState() => _HomePageWithLoginState();
}

class _HomePageWithLoginState extends State<HomePageWithLogin> {
  String email;
  String password;

  final AuthService _auth = AuthService();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    // database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(10000000);

    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: SafeArea(
        child: Column(
          children: [
            // Main title
            SizedBox(
              height: MediaQuery.of(context).size.height > 800 ? 525 : 325,
              child: Container(
                padding: EdgeInsets.only(top: 150),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                      height: 100,
                    ),
                    FadeIn(
                      duration: Duration(seconds: 2),
                      child: Text(
                        'EasyGo',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // TypewriterAnimatedTextKit(
                    //   textAlign: TextAlign.start,
                    //   repeatForever: true,
                    //   speed: Duration(milliseconds: 1000),
                    //   text: ["EazyGo"],
                    //   textStyle: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 50,
                    //     fontFamily: 'Roboto',
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // Login button
            FadeIn(
              duration: Duration(seconds: 2),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: FaIcon(Icons.account_circle),
                label: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                color: Colors.red,
                textColor: Colors.black,
                splashColor: Colors.redAccent,
                padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                onPressed: () {
                  Navigator.pushNamed(context, '/loginscreen');
                },
              ),
            ),

            SizedBox(height: 20.0),

            // Sign up button
            FadeInLeft(
              duration: Duration(seconds: 2),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: FaIcon(FontAwesomeIcons.addressBook),
                label: Text(
                  'Sign up',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                color: Colors.red,
                textColor: Colors.black,
                splashColor: Colors.redAccent,
                padding: EdgeInsets.fromLTRB(73.0, 10.0, 73.0, 10.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/signupscreen');
                },
              ),
            ),

            SizedBox(height: 20.0),

            // Guest Session button
            FadeInRight(
              duration: Duration(seconds: 2),
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: FaIcon(FontAwesomeIcons.signInAlt),
                label: Text(
                  'Guest session',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                color: Colors.red,
                textColor: Colors.black,
                hoverColor: Colors.grey,
                splashColor: Colors.redAccent,
                padding: EdgeInsets.fromLTRB(52.0, 10.0, 52.0, 10.0),
                onPressed: () async {
                  dynamic result = await _auth.signInAnon();
                  // CoolAlert.show(context: context, type: CoolAlertType.loading);
                  CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  );
                  if (result == null) {
                    print('Error Logging in anonymously!');
                  } else {
                    print('Logged in anonymously!');
                    print(result.uid);

                    final locationData = await getCurrentLocation();

                    while (locationData != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/mapscreen',
                        arguments: {
                          'locationData': locationData,
                        },
                      );
                      break;
                    }

                    _firebaseService.userRef().push().set(<String, String>{
                      "id": result.uid,
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

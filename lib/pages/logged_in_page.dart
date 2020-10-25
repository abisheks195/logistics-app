import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LoggedInScreen extends StatefulWidget {
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  Firestore firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  String name = 'Guest!';

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        loggedInUser = user;
        setState(() {
          if (loggedInUser.displayName != null) {
            name = loggedInUser.displayName;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.yellowAccent,
      drawer: new Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height > 800 ? 300 : 200,
              ),
              Divider(
                height: 5,
                thickness: 2,
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user),
                title: Text(
                  'Account',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {},
              ),
              Divider(
                height: 5,
                thickness: 2,
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.shuttleVan),
                title: Text(
                  'Orders',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {},
              ),
              Divider(
                height: 5,
                thickness: 2,
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.signOutAlt),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, '/homescreen');
                },
              ),
              Divider(
                height: 5,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(
            40, MediaQuery.of(context).size.height > 800 ? 100 : 75, 8, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElasticInRight(
              duration: Duration(
                seconds: 1,
                milliseconds: 500,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height > 800 ? 80 : 60,
            ),
            Text(
              'Welcome $name',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 60,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height > 800 ? 120 : 100,
            ),
            Container(
              padding: EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AvatarGlow(
                    glowColor: Colors.blue,
                    endRadius: 130.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: MaterialButton(
                      elevation: 10,
                      shape: CircleBorder(),
                      color: Colors.black87,
                      onPressed: () {
                        Navigator.pushNamed(context, '/uploadimages');
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black87,
                        radius: 70,
                        child: Text(
                          'Move it!',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

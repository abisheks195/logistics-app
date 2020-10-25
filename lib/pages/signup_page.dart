import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_go/utilities/auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();

  String email;
  String password;

  FirebaseUser loggedInUser;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 75),
                  TextFormField(
                    textAlign: TextAlign.start,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Phone Number (Optional)',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      return (!value.contains('@') && value.contains('.'))
                          ? 'Please enter a valid email!'
                          : null;
                    },
                    textAlign: TextAlign.start,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    textAlign: TextAlign.start,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    textAlign: TextAlign.start,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () async {
                      try {
                        final newUser = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if (newUser != null) {
                          Navigator.pushNamed(context, '/loggedinscreen');
                        } else {
                          print('Not yet registered!');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.black,
                          endIndent: 5,
                        ),
                      ),
                      Text('or'),
                      Expanded(
                        child: Divider(
                          height: 20,
                          thickness: 1,
                          indent: 5,
                          endIndent: 0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        onPressed: () async {
                          try {
                            await _auth.signInWithFacebook().whenComplete(() {
                              Navigator.pushNamed(context, '/loggedinscreen');
                            });
                          } catch (e) {
                            print(e.toString());
                            return null;
                          }
                        },
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.google),
                        onPressed: () async {
                          try {
                            await _auth.signInWithGoogle().whenComplete(() {
                              Navigator.pushNamed(context, '/loggedinscreen');
                            });
                          } catch (e) {
                            print(e.toString());
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

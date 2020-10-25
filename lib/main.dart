// Project files
import 'package:easy_go/models/user.dart';
import 'package:easy_go/pages/home_page.dart';
import 'package:easy_go/pages/login_page.dart';
import 'package:easy_go/pages/payment_page.dart';
import 'package:easy_go/utilities/images.dart';
import 'package:easy_go/utilities/introduction_screen.dart';
import 'package:easy_go/pages/maps_page.dart';
import 'package:easy_go/pages/signup_page.dart';
import 'package:easy_go/pages/logged_in_page.dart';
import 'package:easy_go/utilities/auth.dart';
import 'package:easy_go/utilities/wrapper.dart';

// Dependencies
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'EazyGo',
      routes: {
        '/introductionscreen': (context) => IntroductionScreenPage(),
        '/homescreen': (context) => HomePageWithLogin(),
        '/signupscreen': (context) => SignUpScreen(),
        '/loggedinscreen': (context) => LoggedInScreen(),
        '/mapscreen': (context) => MapsPage(),
        '/proceedtopayment': (context) => PaymentScreen(),
        '/uploadimages': (context) => ImageUpload(),
        '/loginscreen': (context) => LoginScreen()
      },
      home: MyAppHomePage(),
    ),
  );
}

class MyAppHomePage extends StatefulWidget {
  @override
  _MyAppHomePageState createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<MyAppHomePage> {
  // bool _initialized = false;
  // bool _error = false;

  // // Define an async function to initialize FlutterFire
  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await FirebaseApp.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch (e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   initializeFlutterFire();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // // Show error message if initialization failed
    // if (_error) {
    //   print('Initialization failed');
    // }

    // // Show a loader until FlutterFire is initialized
    // if (!_initialized) {
    //   print('Initialized!');
    // }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Wrapper(),
        ),
      ),
    );
  }
}

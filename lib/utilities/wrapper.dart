import 'package:easy_go/models/user.dart';
import 'package:easy_go/pages/logged_in_page.dart';
import 'package:easy_go/utilities/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return IntroductionScreenPage();
    } else {
      return LoggedInScreen();
    }
  }
}

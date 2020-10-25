import 'package:easy_go/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionScreenPage extends StatefulWidget {
  @override
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  // final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePageWithLogin()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(
        'assets/images/$assetName.png',
        width: 450,
        height: 300,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      pageColor: Colors.cyan,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      // backgroundColor: Colors.blue,
      body: IntroductionScreen(
        // key: introKey,
        pages: [
          PageViewModel(
            title: "Easy Delivery.",
            body:
                "Want to move things around Melbourne with ease? We'll take care of everything.",
            image: _buildImage('delivery_worker_collection'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Easy Service.",
            body:
                "We will pick it up and deliver it to the given location within 24 hrs.",
            image: _buildImage('phone_with_other_things_surrounded'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Easy Happiness.",
            body: "Just stay at home and make an order, we'll be there.",
            image: _buildImage('phone_with_other_things_surrounded'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Time is money. We save you both.",
            body: "We will be available 24x7 for any kind of support.",
            image: _buildImage('logistics_warehouse'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Don't worry. Trust us!",
            body:
                "Please press the button below and become a member in our family.",
            image: _buildImage('van_reaching_destination'),
            footer: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signupscreen');
              },
              child: Text(
                'SignUp',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text('Skip'),
        next: Icon(Icons.arrow_forward),
        done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
          size: Size(10, 10),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }
}

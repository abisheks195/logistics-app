// import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:confetti/confetti.dart';
import 'package:stripe_payment/stripe_payment.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class LoadingScreenForMap extends StatefulWidget {
//   @override
//   _LoadingScreenForMapState createState() => _LoadingScreenForMapState();
// }

// class _LoadingScreenForMapState extends State<LoadingScreenForMap> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(0xff757575),
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height,
//         maxWidth: MediaQuery.of(context).size.width,
//       ),
//       child: Center(
//         child: SpinKitPulse(
//           color: Colors.blueAccent,
//           duration: Duration(seconds: 2),
//         ),
//       ),
//     );
//   }
// }

String apiKEY = Platform.isAndroid ? "" : "";

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  dynamic currentLocation;
  Map data = {};
  // Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController _mapController;

  ConfettiController _confettiController;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
          publishableKey: "", merchantId: "Test", androidPayMode: "test"),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          error.toString(),
        ),
      ),
    );
    setState(() {
      _error = error.toString();
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    // _mapController.complete(controller);
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    if (data != null && this.mounted) {
      setState(() {
        currentLocation = data['locationData'];
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height > 800 ? 75 : 100,
            ),
            myLocationEnabled: true,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 12,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height > 800 ? 100 : 50,
            left: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loggedinscreen');
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 30,
                color: Colors.grey[700],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height > 800 ? 200 : 150,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SearchMapPlaceWidget(
              apiKey: apiKEY,
              onSelected: (place) async {
                final geolocation = await place.geolocation;
                // final GoogleMapController controller =
                //     await _mapController.future;
                _mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                _mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
          ),
          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height > 800 ? 500 : 400,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            panel: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height > 800 ? 280 : 200,
                  ),
                  Text(
                    'Introducing!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ConfettiWidget(
                    emissionFrequency: 0.05,
                    minBlastForce: 30,
                    numberOfParticles: 50,
                    maxBlastForce: 100,
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      _confettiController.play();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pay on Pick up or Delivery!',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        elevation: 10,
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest(),
                          ).then((paymentMethod) {
                            print('Payment Recieved!');
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Payment Recieved!')));
                            setState(() {
                              _paymentMethod = paymentMethod;
                            });
                          }).catchError(setError);
                        },
                        child: Text(
                          'Pay with a card',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RaisedButton.icon(
                        elevation: 10,
                        padding: EdgeInsets.only(left: 8),
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          StripePayment.paymentRequestWithNativePay(
                            androidPayOptions: AndroidPayPaymentRequest(
                              currencyCode: 'USD',
                              totalPrice: "5",
                            ),
                            applePayOptions: null,
                          ).then((token) {
                            setState(() {
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text('Recieved Payment!')));
                              _paymentToken = token;
                            });
                          }).catchError(setError);
                        },
                        icon: (Platform.isAndroid)
                            ? FaIcon(
                                FontAwesomeIcons.googlePay,
                                color: Colors.white,
                                size: 26,
                              )
                            : FaIcon(
                                FontAwesomeIcons.applePay,
                                color: Colors.white,
                                size: 26,
                              ),
                        label: Text(''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              // margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Center(
                child: Text(
                  'Proceed!',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    fontSize: 23,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null;
  PaymentIntentResult _paymentIntent;
  Source _source;

  ScrollController _controller = ScrollController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
          publishableKey:
              "pk_test_51HcSs3KDEYNGItBL8iwFy9YqQuar971Uviz3kRzb1cA9esLMnuMIWEp3KccLq1XsWXxiforbWe4sl5QcsAoPNNF200LYoclKUm",
          merchantId: "Test",
          androidPayMode: "test"),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              ListView(
                controller: _controller,
                shrinkWrap: true,
                padding: EdgeInsets.all(100),
                children: [
                  RaisedButton(
                    onPressed: () {
                      StripePayment.paymentRequestWithCardForm(
                              CardFormPaymentRequest())
                          .then((paymentMethod) {
                        print('Payment Recieved!');
                        // _scaffoldKey.currentState.showSnackBar(SnackBar(
                        //     content: Text('Recieved ${paymentMethod.id}')));
                        setState(() {
                          _paymentMethod = paymentMethod;
                        });
                      }).catchError(setError);
                    },
                    child: Text('Create Payment with card!'),
                  )
                ],
              ),
              RaisedButton.icon(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  setState(() {
                    _source = null;
                    _paymentIntent = null;
                    _paymentMethod = null;
                    _paymentToken = null;
                  });
                },
                icon: Icon(
                  Icons.clear,
                ),
                label: Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

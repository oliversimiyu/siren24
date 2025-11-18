import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../my-globals.dart' as globals;
import '../services/ride_notification_service.dart';

class PaymentPage extends StatefulWidget {
  static String id = 'payment';
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_EuF395pyMv8oc1",
      "amount": globals.amount * 100,
      "name": "Siren 24",
      "description": "Payment forAmbulance service",
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    print("Payment success");
    globals.paymentDone = true;

    // Send payment success notification
    RideNotificationService.sendPaymentCompletedNotification(
      amount: globals.amount,
      paymentMethod: "Razorpay",
    );

    // Send ride completed notification
    RideNotificationService.sendRideCompletedNotification(
      destination:
          globals.locationto.isNotEmpty ? globals.locationto : "Destination",
      amount: globals.amount,
    );

    // Navigate back or show success message
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful! Thank you for using our service.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void handlerErrorFailure() {
    print("Payment error");

    // Send payment failure notification
    RideNotificationService.sendPaymentFailedNotification(
      amount: globals.amount,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment failed. Please try again or contact support.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void handlerExternalWallet() {
    print("External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(child: SizedBox()),
              Image.asset('assets/mainlogo.png'),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  openCheckout();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Color(0xFF4C6EE4),
                  ),
                  height: 50,
                  width: width - 20,
                  child: Center(
                    child: Text(
                      'pay online',
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Roboto',
                          wordSpacing: 2,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*  GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Color(0xFF4C6EE4),
                  ),
                  height: 50,
                  width: width - 20,
                  child: Center(
                    child: Text(
                      'pay in cash',
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Roboto',
                          wordSpacing: 2,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ), */
              Expanded(child: SizedBox()),
            ],
          ),
        ));
  }
}

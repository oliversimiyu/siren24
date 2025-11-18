import 'package:flutter/material.dart';
import 'package:siren24/my-globals.dart';
import 'package:siren24/state/api_calling.dart';
import '../my-globals.dart' as globals;
import '../services/ride_notification_service.dart';
import '../payments/payment.dart';

class Driver_info extends StatefulWidget {
  final DraggableScrollableController infocontroller;
  final VoidCallback cancel;

  Driver_info({required this.infocontroller, required this.cancel, Key? key})
      : super(key: key);

  @override
  State<Driver_info> createState() => _Driver_infoState();
}

class _Driver_infoState extends State<Driver_info> {
  void _completeRide() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C6EE5)),
              ),
              SizedBox(height: 20),
              Text(
                'Completing ride...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    // Simulate ride completion delay
    await Future.delayed(Duration(seconds: 2));

    // Send ride completed notification
    await RideNotificationService.sendRideCompletedNotification(
      destination:
          globals.locationto.isNotEmpty ? globals.locationto : "Destination",
      amount: globals.amount,
    );

    Navigator.of(context).pop(); // Close loading dialog

    // Show ride completed dialog with payment option
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flag,
                  size: 60,
                  color: Color(0xFF4C6EE5),
                ),
                SizedBox(height: 20),
                Text(
                  'Ride Completed!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You have reached your destination.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'KSH ${globals.amount}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C6EE5),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context)
                              .pop(); // Close driver info sheet
                          // Navigate to payment
                          Navigator.pushNamed(context, PaymentPage.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C6EE5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context)
                              .pop(); // Close driver info sheet
                          // Simulate cash payment
                          _simulateCashPayment();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Pay Cash',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulateCashPayment() async {
    // Simulate cash payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C6EE5)),
            ),
            SizedBox(height: 20),
            Text('Processing cash payment...'),
          ],
        ),
      ),
    );

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop(); // Close loading

    // Send payment completed notification
    await RideNotificationService.sendPaymentCompletedNotification(
      amount: globals.amount,
      paymentMethod: "Cash",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Cash payment confirmed! Thank you for using our service.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Container check() {
    if (bookingSuccessful)
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white),
        child: ListView(
          children: [
            Container(
              height: 68,
              color: Color(0XFFF7F7F7),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(globals.drimage),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          globals.drivername,
                          style: TextStyle(
                              fontSize: 17,
                              decoration: TextDecoration.none,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Image.asset('assets/star.png'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              globals.drrating.toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        ApiCaller()
                            .launchPhoneDialer(globals.driverphone.toString());
                      },
                      child: Image.asset('assets/call.png'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 76,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    children: [
                      Image.asset('assets/ambsymb.png'),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Text(
                              'Vehicle No.',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  color: Colors.grey,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              globals.vhno,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Text(
                              'Vehicle Type',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.none,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ALSW1',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: 76,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Image.asset('assets/road.png'),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Distance',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                color: Colors.grey,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            globals.totaldistance,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            globals.amount.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              color: Colors.white,
              child: Column(
                children: [
                  // Complete Ride Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _completeRide,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color(0xFF4C6EE5),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            'Complete Ride & Pay',
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                wordSpacing: 1,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Cancel Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: widget.cancel,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border:
                              Border.all(color: Color(0xFF242E42), width: 2),
                          color: Colors.white,
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            'Cancel Request',
                            style: TextStyle(
                                fontSize: 19,
                                color: Color(0xFF242E42),
                                fontFamily: 'Roboto',
                                wordSpacing: 1,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400),
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
      );
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return check();
  }
}

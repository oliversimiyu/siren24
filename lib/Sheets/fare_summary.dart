import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:siren24/Sheets/Driver_info.dart';
import 'package:siren24/basescreen/home_screen.dart';
import 'date_picker.dart';
import '../my-globals.dart' as globals;
import '../services/ride_history_service.dart';
import '../services/ride_notification_service.dart';

class FareSummary extends StatefulWidget {
  final DraggableScrollableController farecontroller;
  final int? total;
  final int? addonsprice;
  final int? ambprice;
  final String destinationname;
  final VoidCallback dates;

  FareSummary(
      {required this.farecontroller,
      required this.total,
      required this.destinationname,
      required this.addonsprice,
      required this.ambprice,
      required this.dates,
      Key? key})
      : super(key: key);

  @override
  State<FareSummary> createState() => _FareSummaryState();
}

class _FareSummaryState extends State<FareSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Location Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 30,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.destinationname,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Fare Summary Title
            const Center(
              child: Text(
                'Fare Summary',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Pricing Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildPriceRow(
                      'Ambulance Service', 'KSH ${widget.ambprice}', false),
                  const SizedBox(height: 12),
                  _buildPriceRow('Additional Facilities',
                      'KSH ${widget.addonsprice}', false),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 15),
                  _buildPriceRow('Total Amount', 'KSH ${widget.total}', true),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Book Now',
                    const Color(0xFF4C6EE5),
                    Colors.white,
                    () => _handleBookNow(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    'Book Later',
                    Colors.white,
                    const Color(0xFF4C6EE5),
                    () => Navigator.pushNamed(context, Date_select.id),
                    borderColor: const Color(0xFF4C6EE5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? const Color(0xFF4C6EE5) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed, {
    Color? borderColor,
  }) {
    return Container(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: backgroundColor == Colors.white ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _handleBookNow() {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C6EE5)),
          ),
        );
      },
    );

    // Set mock driver data immediately for fast response
    _setMockDriverData();

    // Simulate API call with shorter delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close loading dialog
      _showBookingConfirmation();
    });
  }

  void _setMockDriverData() {
    // Set mock data in globals for the driver info screen
    globals.bookingSuccessful = true;
    globals.drivername = "Samuel Kiprotich";
    globals.driverphone = 254712345678;
    globals.drrating = 5;
    globals.vhno = "KDB 123A";
    globals.drimage =
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face";
    globals.amount = widget.total ?? 0;

    // Save ride to history and send notifications
    _saveRideToHistory();
    _sendRideNotifications();
  }

  Future<void> _saveRideToHistory() async {
    try {
      await RideHistoryService.saveRideToHistory(
        sourceAddress:
            "Current Location", // You might want to get this from globals or widget
        destinationAddress: widget.destinationname,
        sourceLat: globals.currlat ?? 0.0,
        sourceLng: globals.currentlng ?? 0.0,
        destinationLat: globals.destilat ?? 0.0,
        destinationLng: globals.destilng ?? 0.0,
        amount: widget.total ?? 0,
        orderType: 'immediate',
        driverName: globals.drivername,
        driverPhone: globals.driverphone.toString(),
        vehicleNumber: globals.vhno,
      );
    } catch (e) {
      print('Failed to save ride to history: $e');
    }
  }

  Future<void> _sendRideNotifications() async {
    try {
      // Send ride booked notification
      await RideNotificationService.sendRideBookedNotification(
        rideType: 'immediate',
        destination: widget.destinationname,
        amount: widget.total ?? 0,
      );

      // Simulate driver assignment notification after a delay
      Future.delayed(const Duration(seconds: 5), () async {
        await RideNotificationService.sendDriverAssignedNotification(
          driverName: globals.drivername,
          vehicleNumber: globals.vhno,
          estimatedArrival: "5-10 minutes",
        );
      });

      // Simulate driver arrival notification
      Future.delayed(const Duration(seconds: 15), () async {
        await RideNotificationService.sendDriverArrivedNotification(
          driverName: globals.drivername,
          vehicleNumber: globals.vhno,
        );
      });

      // Simulate ride started notification
      Future.delayed(const Duration(seconds: 25), () async {
        await RideNotificationService.sendRideStartedNotification(
          destination: widget.destinationname,
          driverName: globals.drivername,
        );
      });
    } catch (e) {
      print('Failed to send ride notifications: $e');
    }
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Your ambulance has been booked successfully.\nThe driver will contact you shortly.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      driver_info();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C6EE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'View Driver Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void driver_info() {
    showFlexibleBottomSheet<void>(
      minHeight: 0.2,
      initHeight: 0.4,
      maxHeight: 0.4,
      isCollapsible: false,
      context: context,
      builder: (context, controller, offset) {
        return Driver_info(
          infocontroller: DraggableScrollableController(),
          cancel: () {
            _showCancelBookingDialog();
          },
        );
      },
      anchors: [0.2, 0.4],
    );
  }

  void _showCancelBookingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Cancel Booking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this booking?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close dialog

                      // Show loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4C6EE5)),
                          ),
                        ),
                      );

                      // Simulate API call
                      await Future.delayed(const Duration(seconds: 1));

                      Navigator.of(context).pop(); // Close loading

                      // Send cancellation notification
                      await RideNotificationService
                          .sendRideCancelledNotification(
                        destination: widget.destinationname,
                        reason: "Cancelled by user",
                      );

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking cancelled successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate to home
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        HomeScreen.id,
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF4C6EE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Yes, Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'No, Keep',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

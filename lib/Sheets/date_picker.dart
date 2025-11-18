import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siren24/state/api_calling.dart';
import '../Models/cancel_booking.dart';
import '../basescreen/home_screen.dart';
import 'Driver_info.dart';
import '../my-globals.dart' as globals;
import '../services/ride_history_service.dart';
import '../services/ride_notification_service.dart';

class Date_select extends StatefulWidget {
  static String id = 'date_picker';
  Date_select({Key? key}) : super(key: key);

  @override
  State<Date_select> createState() => _Date_selectState();
}

class _Date_selectState extends State<Date_select> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool _timeControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current date and time
    _dateController.text = DateFormat('MMMM dd, yyyy').format(selectedDate);
    // Don't use context in initState - will be set in build method
  }

  @override
  Widget build(BuildContext context) {
    // Initialize time controller only once when context is available
    if (!_timeControllerInitialized) {
      String period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
      int hour =
          selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
      _timeController.text =
          '$hour:${selectedTime.minute.toString().padLeft(2, '0')} $period';
      _timeControllerInitialized = true;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Schedule Booking',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4C6EE5), Color(0xFF6C7CE5)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4C6EE5).withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Schedule Your Ambulance',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred date and time',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C6EE5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4C6EE5),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _dateController.text.isNotEmpty
                                ? _dateController.text
                                : 'Select Date',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C6EE5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Color(0xFF4C6EE5),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _timeController.text.isNotEmpty
                                ? _timeController.text
                                : 'Select Time',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Quick Time Suggestions
            const Text(
              'Quick Select',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildQuickTimeButton('In 1 Hour', 1)),
                const SizedBox(width: 10),
                Expanded(child: _buildQuickTimeButton('In 2 Hours', 2)),
                const SizedBox(width: 10),
                Expanded(child: _buildQuickTimeButton('Tomorrow', 24)),
              ],
            ),

            const SizedBox(height: 40),
            // Confirm Button
            Container(
              width: double.infinity,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: ElevatedButton(
                onPressed: _isFormValid() ? _confirmBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C6EE5),
                  disabledBackgroundColor: Colors.grey[300],
                  elevation: _isFormValid() ? 8 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: const Color(0xFF4C6EE5).withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: _isFormValid() ? Colors.white : Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _isFormValid() ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Method to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4C6EE5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(selectedDate);
      });
    }
  }

  // Method to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4C6EE5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        // Use a simple format instead of context-dependent formatting
        String period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
        int hour =
            selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
        _timeController.text =
            '$hour:${selectedTime.minute.toString().padLeft(2, '0')} $period';
      });
    }
  }

  // Method to build quick time selection buttons
  Widget _buildQuickTimeButton(String label, int hoursFromNow) {
    return GestureDetector(
      onTap: () {
        DateTime newDateTime =
            DateTime.now().add(Duration(hours: hoursFromNow));
        setState(() {
          selectedDate = newDateTime;
          selectedTime = TimeOfDay.fromDateTime(newDateTime);
          _dateController.text =
              DateFormat('MMMM dd, yyyy').format(selectedDate);
          // Use a simple format instead of context-dependent formatting
          String period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
          int hour =
              selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
          _timeController.text =
              '$hour:${selectedTime.minute.toString().padLeft(2, '0')} $period';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF4C6EE5).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4C6EE5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Method to check if form is valid
  bool _isFormValid() {
    return _dateController.text.isNotEmpty && _timeController.text.isNotEmpty;
  }

  // Method to handle booking confirmation
  void _confirmBooking() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both date and time'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading dialog
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

    try {
      // Use mock booking system instead of real API
      await _mockBookingProcess();

      Navigator.of(context).pop(); // Close loading dialog
      _showBookingSuccessDialog();
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${e.toString()}. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Mock booking process for demo purposes
  Future<void> _mockBookingProcess() async {
    // Simulate API processing time
    await Future.delayed(const Duration(seconds: 2));

    // Mock success scenario (95% success rate for demo)
    if (DateTime.now().millisecond % 20 == 0) {
      // 5% chance of failure for testing
      throw Exception('Network timeout');
    }

    // Mock setting global booking data for the app
    // This simulates what the real API would set
    globals.bookingSuccessful = true;
    globals.drivername = "Samuel Kiprotich";
    globals.driverphone = 254712345678;
    globals.drrating = 5;
    globals.vhno = "KDB 123A";
    globals.drimage = "https://via.placeholder.com/100";
    globals.amount = 2500; // KSH 2500

    // Save scheduled ride to history and send notifications
    await _saveScheduledRideToHistory();
    await _sendScheduledRideNotifications();

    return;
  }

  Future<void> _saveScheduledRideToHistory() async {
    try {
      await RideHistoryService.saveRideToHistory(
        sourceAddress:
            globals.location.isNotEmpty ? globals.location : "Current Location",
        destinationAddress: globals.locationto.isNotEmpty
            ? globals.locationto
            : "Selected Destination",
        sourceLat: globals.currlat ?? 0.0,
        sourceLng: globals.currentlng ?? 0.0,
        destinationLat: globals.destilat ?? 0.0,
        destinationLng: globals.destilng ?? 0.0,
        amount: globals.amount,
        orderType: 'scheduled',
        scheduledDate: _dateController.text,
        scheduledTime: _timeController.text,
        driverName: globals.drivername,
        driverPhone: globals.driverphone.toString(),
        vehicleNumber: globals.vhno,
      );
    } catch (e) {
      print('Failed to save scheduled ride to history: $e');
    }
  }

  Future<void> _sendScheduledRideNotifications() async {
    try {
      // Send scheduled ride booked notification
      await RideNotificationService.sendRideBookedNotification(
        rideType: 'scheduled',
        destination: globals.locationto.isNotEmpty
            ? globals.locationto
            : "Selected Destination",
        amount: globals.amount,
        scheduledTime: '${_dateController.text} at ${_timeController.text}',
      );

      // Send reminder notification (simulate reminder 1 hour before)
      Future.delayed(const Duration(seconds: 10), () async {
        await RideNotificationService.sendRideReminderNotification(
          destination: globals.locationto.isNotEmpty
              ? globals.locationto
              : "Selected Destination",
          scheduledTime: _timeController.text,
          minutesBefore: 60,
        );
      });
    } catch (e) {
      print('Failed to send scheduled ride notifications: $e');
    }
  }

  // Method to show booking success dialog
  void _showBookingSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  'Booking Scheduled!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Your ambulance has been scheduled for ${_dateController.text} at ${_timeController.text}.\n\nWe will contact you before the scheduled time.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
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
                      'View Booking Details',
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

  // Method to show cancel booking dialog
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

                      try {
                        // Simulate API call
                        CancelBooking reply = await ApiCaller().CancelOrder();
                        await Future.delayed(const Duration(seconds: 1));

                        Navigator.of(context).pop(); // Close loading

                        // Send cancellation notification
                        await RideNotificationService
                            .sendRideCancelledNotification(
                          destination: globals.locationto.isNotEmpty
                              ? globals.locationto
                              : "Selected Destination",
                          reason: "Cancelled by user",
                        );

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(reply.message ??
                                'Booking cancelled successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Navigate to home
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeScreen.id,
                          (route) => false,
                        );
                      } catch (e) {
                        Navigator.of(context).pop(); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to cancel booking'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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

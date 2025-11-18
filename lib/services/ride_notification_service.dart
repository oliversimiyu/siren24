import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class RideNotificationService {
  static const String _notificationsKey = 'notifications';

  // Initialize notification channels
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'ride_notifications',
          channelName: 'Ride Notifications',
          channelDescription:
              'Notifications for ride booking and status updates',
          defaultColor: const Color(0xFF4C6EE5),
          ledColor: const Color(0xFF4C6EE5),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: true,
          criticalAlerts: false,
        ),
      ],
    );
  }

  // Send notification for ride booked
  static Future<void> sendRideBookedNotification({
    required String rideType, // 'immediate' or 'scheduled'
    required String destination,
    required int amount,
    String? scheduledTime,
  }) async {
    String title = rideType == 'scheduled'
        ? 'Ride Scheduled Successfully!'
        : 'Ride Booked Successfully!';

    String body = rideType == 'scheduled'
        ? 'Your ambulance to $destination has been scheduled${scheduledTime != null ? " for $scheduledTime" : ""}. Amount: KSH $amount'
        : 'Your ambulance to $destination has been booked. Driver will contact you shortly. Amount: KSH $amount';

    await _showNotification(
      title: title,
      body: body,
      category: 'ride_booked',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'ride_booked',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for ride cancelled
  static Future<void> sendRideCancelledNotification({
    required String destination,
    String? reason,
  }) async {
    String title = 'Ride Cancelled';
    String body =
        'Your ride to $destination has been cancelled${reason != null ? ". Reason: $reason" : ""}. Any charges will be refunded within 24 hours.';

    await _showNotification(
      title: title,
      body: body,
      category: 'ride_cancelled',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'ride_cancelled',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for driver assigned
  static Future<void> sendDriverAssignedNotification({
    required String driverName,
    required String vehicleNumber,
    required String estimatedArrival,
  }) async {
    String title = 'Driver Assigned';
    String body =
        '$driverName has been assigned to your ride. Vehicle: $vehicleNumber. Estimated arrival: $estimatedArrival';

    await _showNotification(
      title: title,
      body: body,
      category: 'driver_assigned',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'driver_assigned',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for driver arrival
  static Future<void> sendDriverArrivedNotification({
    required String driverName,
    required String vehicleNumber,
  }) async {
    String title = 'Driver Arrived';
    String body =
        '$driverName has arrived at your location. Vehicle: $vehicleNumber. Please proceed to the ambulance.';

    await _showNotification(
      title: title,
      body: body,
      category: 'driver_arrived',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'driver_arrived',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for ride started
  static Future<void> sendRideStartedNotification({
    required String destination,
    required String driverName,
  }) async {
    String title = 'Ride Started';
    String body =
        'Your ride to $destination has started with $driverName. Have a safe journey!';

    await _showNotification(
      title: title,
      body: body,
      category: 'ride_started',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'ride_started',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for ride completed
  static Future<void> sendRideCompletedNotification({
    required String destination,
    required int amount,
  }) async {
    String title = 'Ride Completed';
    String body =
        'You have arrived at $destination. Ride completed successfully. Total amount: KSH $amount. Please proceed with payment.';

    await _showNotification(
      title: title,
      body: body,
      category: 'ride_completed',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'ride_completed',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for payment completed
  static Future<void> sendPaymentCompletedNotification({
    required int amount,
    required String paymentMethod,
  }) async {
    String title = 'Payment Successful';
    String body =
        'Payment of KSH $amount has been processed successfully via $paymentMethod. Thank you for using our service!';

    await _showNotification(
      title: title,
      body: body,
      category: 'payment_completed',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'payment_completed',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for payment failed
  static Future<void> sendPaymentFailedNotification({
    required int amount,
  }) async {
    String title = 'Payment Failed';
    String body =
        'Payment of KSH $amount could not be processed. Please try again or contact support.';

    await _showNotification(
      title: title,
      body: body,
      category: 'payment_failed',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'payment_failed',
      timestamp: DateTime.now(),
    );
  }

  // Send notification for ride reminder (for scheduled rides)
  static Future<void> sendRideReminderNotification({
    required String destination,
    required String scheduledTime,
    required int minutesBefore,
  }) async {
    String title = 'Ride Reminder';
    String body =
        'Your scheduled ride to $destination is in $minutesBefore minutes ($scheduledTime). Please be ready.';

    await _showNotification(
      title: title,
      body: body,
      category: 'ride_reminder',
    );

    await _saveNotification(
      title: title,
      body: body,
      category: 'ride_reminder',
      timestamp: DateTime.now(),
    );
  }

  // Private method to show system notification
  static Future<void> _showNotification({
    required String title,
    required String body,
    required String category,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'ride_notifications',
          title: title,
          body: body,
          displayOnBackground: true,
          displayOnForeground: true,
          largeIcon: 'asset://icons/card.png',
          category: NotificationCategory.Transport,
          wakeUpScreen: true,
          criticalAlert:
              category == 'driver_arrived' || category == 'ride_completed',
        ),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  // Private method to save notification to local storage
  static Future<void> _saveNotification({
    required String title,
    required String body,
    required String category,
    required DateTime timestamp,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> notifications = prefs.getStringList(_notificationsKey) ?? [];

      // Create notification entry in the format expected by the existing notification screen
      // Format: "id~body~title~category~timestamp"
      String notificationEntry =
          "${timestamp.millisecondsSinceEpoch}~$body~$title~$category~${timestamp.toIso8601String()}";

      // Add to beginning of list (most recent first)
      notifications.insert(0, notificationEntry);

      // Limit to 100 notifications to prevent excessive storage
      if (notifications.length > 100) {
        notifications = notifications.take(100).toList();
      }

      await prefs.setStringList(_notificationsKey, notifications);
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  // Get all notifications
  static Future<List<Map<String, dynamic>>> getAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> notifications = prefs.getStringList(_notificationsKey) ?? [];

      return notifications.map((notificationString) {
        List<String> parts = notificationString.split('~');
        if (parts.length >= 5) {
          return {
            'id': parts[0],
            'body': parts[1],
            'title': parts[2],
            'category': parts[3],
            'timestamp': parts[4],
          };
        }
        return {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'body': parts.length > 1 ? parts[1] : 'Unknown notification',
          'title': parts.length > 2 ? parts[2] : 'Notification',
          'category': 'general',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  // Clear all notifications
  static Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  // Delete specific notification
  static Future<void> deleteNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> notifications = prefs.getStringList(_notificationsKey) ?? [];

      notifications.removeWhere((notification) {
        List<String> parts = notification.split('~');
        return parts.isNotEmpty && parts[0] == id;
      });

      await prefs.setStringList(_notificationsKey, notifications);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Get notification icon based on category
  static String getNotificationIcon(String category) {
    switch (category) {
      case 'ride_booked':
        return 'check_circle';
      case 'ride_cancelled':
        return 'cancel';
      case 'driver_assigned':
        return 'person';
      case 'driver_arrived':
        return 'location_on';
      case 'ride_started':
        return 'directions';
      case 'ride_completed':
        return 'flag';
      case 'payment_completed':
        return 'payment';
      case 'payment_failed':
        return 'error';
      case 'ride_reminder':
        return 'schedule';
      default:
        return 'notifications';
    }
  }

  // Get notification color based on category
  static Color getNotificationColor(String category) {
    switch (category) {
      case 'ride_booked':
      case 'driver_assigned':
      case 'ride_started':
      case 'payment_completed':
        return const Color(0xFF4CAF50); // Green
      case 'ride_cancelled':
      case 'payment_failed':
        return const Color(0xFFF44336); // Red
      case 'driver_arrived':
      case 'ride_completed':
        return const Color(0xFF4C6EE5); // Blue
      case 'ride_reminder':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}

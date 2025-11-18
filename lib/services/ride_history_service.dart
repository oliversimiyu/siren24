import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/history_model.dart';

class RideHistoryService {
  static const String _rideHistoryKey = 'ride_history';

  // Save a new ride to history
  static Future<bool> saveRideToHistory({
    required String sourceAddress,
    required String destinationAddress,
    required double sourceLat,
    required double sourceLng,
    required double destinationLat,
    required double destinationLng,
    required int amount,
    required String orderType, // 'immediate' or 'scheduled'
    String? scheduledDate,
    String? scheduledTime,
    String? driverName,
    String? driverPhone,
    String? vehicleNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing history
      List<Map<String, dynamic>> history = await getRideHistory();

      // Generate a unique ID for this ride
      String rideId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create new ride entry
      Map<String, dynamic> newRide = {
        'id': rideId,
        'userid': 'local_user', // Since we're using local storage
        'driverid': driverName ?? 'Unknown Driver',
        'ambulanceid': vehicleNumber ?? 'Unknown Vehicle',
        'orderStatus': 'Completed',
        'source': {
          'lat': sourceLat,
          'lng': sourceLng,
          'address': sourceAddress,
        },
        'destination': {
          'lat': destinationLat,
          'lng': destinationLng,
          'address': destinationAddress,
        },
        'orderType': orderType,
        'orderDate': DateTime.now().toIso8601String(),
        'scheduledDate': scheduledDate,
        'scheduledTime': scheduledTime,
        'completedDate': DateTime.now().toIso8601String(),
        'orderAmount': amount,
        'orderDistance': 0, // Can be calculated if needed
        'paymentMethod': 'Mock Payment',
        'driverName': driverName,
        'driverPhone': driverPhone,
        'vehicleNumber': vehicleNumber,
      };

      // Add to beginning of list (most recent first)
      history.insert(0, newRide);

      // Limit history to last 50 rides to prevent excessive storage
      if (history.length > 50) {
        history = history.take(50).toList();
      }

      // Save updated history
      String historyJson = jsonEncode(history);
      await prefs.setString(_rideHistoryKey, historyJson);

      return true;
    } catch (e) {
      print('Error saving ride to history: $e');
      return false;
    }
  }

  // Get all ride history
  static Future<List<Map<String, dynamic>>> getRideHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? historyJson = prefs.getString(_rideHistoryKey);

      if (historyJson == null) {
        return [];
      }

      List<dynamic> historyList = jsonDecode(historyJson);
      return historyList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting ride history: $e');
      return [];
    }
  }

  // Convert local history to HistoryModel objects
  static Future<List<HistoryModel>> getHistoryModels() async {
    try {
      List<Map<String, dynamic>> localHistory = await getRideHistory();

      List<HistoryModel> historyModels = localHistory.map((ride) {
        return HistoryModel(
          id: ride['id'],
          userid: ride['userid'],
          driverid: ride['driverid'],
          ambulanceid: ride['ambulanceid'],
          orderStatus: ride['orderStatus'],
          source: Source(
            lat: ride['source']['lat'],
            lng: ride['source']['lng'],
          ),
          destination: Destination(
            lat: ride['destination']['lat'],
            lng: ride['destination']['lng'],
          ),
          orderType: ride['orderType'],
          orderDate: ride['orderDate'],
          completedDate: ride['completedDate'],
          orderAmount: ride['orderAmount'],
          orderDistance: ride['orderDistance'],
          paymentMethod: ride['paymentMethod'],
        );
      }).toList();

      return historyModels;
    } catch (e) {
      print('Error converting to HistoryModel: $e');
      return [];
    }
  }

  // Get ride details including custom fields
  static Future<Map<String, dynamic>?> getRideDetails(String rideId) async {
    try {
      List<Map<String, dynamic>> history = await getRideHistory();

      for (Map<String, dynamic> ride in history) {
        if (ride['id'] == rideId) {
          return ride;
        }
      }

      return null;
    } catch (e) {
      print('Error getting ride details: $e');
      return null;
    }
  }

  // Clear all ride history
  static Future<bool> clearRideHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rideHistoryKey);
      return true;
    } catch (e) {
      print('Error clearing ride history: $e');
      return false;
    }
  }

  // Delete a specific ride
  static Future<bool> deleteRide(String rideId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> history = await getRideHistory();

      history.removeWhere((ride) => ride['id'] == rideId);

      String historyJson = jsonEncode(history);
      await prefs.setString(_rideHistoryKey, historyJson);

      return true;
    } catch (e) {
      print('Error deleting ride: $e');
      return false;
    }
  }
}

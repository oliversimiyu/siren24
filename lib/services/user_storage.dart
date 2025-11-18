import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // Save user registration data
  static Future<bool> registerUser({
    required String phone,
    required String name,
    String? email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing users
      List<Map<String, dynamic>> users = await getRegisteredUsers();

      // Check if user already exists
      bool userExists = users.any((user) => user['phone'] == phone);
      if (userExists) {
        return false; // User already exists
      }

      // Add new user
      Map<String, dynamic> newUser = {
        'phone': phone,
        'name': name,
        'email': email ?? '',
        'registrationDate': DateTime.now().toIso8601String(),
      };

      users.add(newUser);

      // Save updated users list
      String usersJson = jsonEncode(users);
      await prefs.setString(_usersKey, usersJson);

      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Get all registered users
  static Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? usersJson = prefs.getString(_usersKey);

      if (usersJson == null) {
        return [];
      }

      List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting registered users: $e');
      return [];
    }
  }

  // Login user (check if phone number exists in registered users)
  static Future<Map<String, dynamic>?> loginUser(String phone) async {
    try {
      List<Map<String, dynamic>> users = await getRegisteredUsers();

      // Find user by phone number
      for (Map<String, dynamic> user in users) {
        if (user['phone'] == phone) {
          // Save as current user
          await setCurrentUser(user);
          return user;
        }
      }

      return null; // User not found
    } catch (e) {
      print('Error logging in user: $e');
      return null;
    }
  }

  // Set current logged-in user
  static Future<void> setCurrentUser(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userJson = jsonEncode(user);
      await prefs.setString(_currentUserKey, userJson);
    } catch (e) {
      print('Error setting current user: $e');
    }
  }

  // Get current logged-in user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString(_currentUserKey);

      if (userJson == null) {
        return null;
      }

      return jsonDecode(userJson);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Logout user
  static Future<void> logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
    } catch (e) {
      print('Error logging out user: $e');
    }
  }

  // Clear session-specific data while preserving registered users
  static Future<void> clearSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove current user session
      await prefs.remove(_currentUserKey);

      // Remove other session-specific keys (add as needed)
      await prefs.remove('authtoken');
      await prefs.remove('user_session');
      await prefs.remove('fcm_token');
      // Add any other session-specific keys that need to be cleared

      // NOTE: We deliberately DO NOT remove _usersKey to preserve registered users
    } catch (e) {
      print('Error clearing session data: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    Map<String, dynamic>? currentUser = await getCurrentUser();
    return currentUser != null;
  }

  // Update user profile
  static Future<bool> updateUserProfile({
    required String phone,
    String? name,
    String? email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all users
      List<Map<String, dynamic>> users = await getRegisteredUsers();

      // Find and update user
      for (int i = 0; i < users.length; i++) {
        if (users[i]['phone'] == phone) {
          if (name != null) users[i]['name'] = name;
          if (email != null) users[i]['email'] = email;
          users[i]['lastUpdated'] = DateTime.now().toIso8601String();
          break;
        }
      }

      // Save updated users list
      String usersJson = jsonEncode(users);
      await prefs.setString(_usersKey, usersJson);

      // Update current user if it's the same user
      Map<String, dynamic>? currentUser = await getCurrentUser();
      if (currentUser != null && currentUser['phone'] == phone) {
        if (name != null) currentUser['name'] = name;
        if (email != null) currentUser['email'] = email;
        await setCurrentUser(currentUser);
      }

      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }
}

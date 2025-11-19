import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  // Navigate to named route
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  // Navigate and replace current route
  Future<dynamic> navigateAndReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  // Navigate and clear stack
  Future<dynamic> navigateAndClearStack(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Go back
  void goBack({dynamic result}) {
    navigatorKey.currentState!.pop(result);
  }

  // Check if can go back
  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  // Navigate to main navigation with specific index
  void navigateToMainWith({int initialIndex = 0}) {
    navigateAndReplace('/main_navigation',
        arguments: {'initialIndex': initialIndex});
  }

  // Show custom snackbar
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: 20,
                ),
                SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor ?? Color(0xFF4C6EE5),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  // Show error message
  void showError(String message) {
    showSnackBar(
      message,
      backgroundColor: Color(0xffEE2417),
      icon: Icons.error_outline,
    );
  }

  // Show success message
  void showSuccess(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  // Show info message
  void showInfo(String message) {
    showSnackBar(
      message,
      backgroundColor: Color(0xFF4C6EE5),
      icon: Icons.info_outline,
    );
  }

  // Show warning message
  void showWarning(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_outlined,
    );
  }

  // Show loading dialog
  void showLoadingDialog({String message = 'Loading...'}) {
    final context = currentContext;
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C6EE5)),
              ),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Hide loading dialog
  void hideLoadingDialog() {
    if (canGoBack()) {
      goBack();
    }
  }

  // Show confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    final context = currentContext;
    if (context != null) {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? Color(0xffEE2417),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                confirmText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }
}

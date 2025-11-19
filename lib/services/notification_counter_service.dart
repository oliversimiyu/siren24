import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCounterService extends ChangeNotifier {
  static final NotificationCounterService _instance =
      NotificationCounterService._internal();
  factory NotificationCounterService() => _instance;
  NotificationCounterService._internal();

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  // Initialize notification count from storage
  Future<void> initializeCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];

      // Count unread notifications (you can implement your own logic here)
      // For now, let's assume all notifications are unread initially
      _unreadCount = notifications.length;
      notifyListeners();
    } catch (e) {
      print('Error initializing notification count: $e');
    }
  }

  // Add new notification
  void addNotification() {
    _unreadCount++;
    _saveCount();
    notifyListeners();
  }

  // Mark notification as read
  void markAsRead([int count = 1]) {
    _unreadCount = (_unreadCount - count).clamp(0, _unreadCount);
    _saveCount();
    notifyListeners();
  }

  // Mark all notifications as read
  void markAllAsRead() {
    _unreadCount = 0;
    _saveCount();
    notifyListeners();
  }

  // Set specific count
  void setCount(int count) {
    _unreadCount = count.clamp(0, 999); // Max 999 notifications
    _saveCount();
    notifyListeners();
  }

  // Save count to storage
  Future<void> _saveCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('unread_notification_count', _unreadCount);
    } catch (e) {
      print('Error saving notification count: $e');
    }
  }

  // Load count from storage
  Future<void> loadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _unreadCount = prefs.getInt('unread_notification_count') ?? 0;
      notifyListeners();
    } catch (e) {
      print('Error loading notification count: $e');
    }
  }
}

// Widget to display notification badge
class NotificationBadgeWidget extends StatefulWidget {
  final Widget child;
  final int? customCount;
  final Color? badgeColor;
  final Color? textColor;
  final double? badgeSize;

  const NotificationBadgeWidget({
    Key? key,
    required this.child,
    this.customCount,
    this.badgeColor,
    this.textColor,
    this.badgeSize,
  }) : super(key: key);

  @override
  _NotificationBadgeWidgetState createState() =>
      _NotificationBadgeWidgetState();
}

class _NotificationBadgeWidgetState extends State<NotificationBadgeWidget> {
  final NotificationCounterService _notificationService =
      NotificationCounterService();

  @override
  void initState() {
    super.initState();
    _notificationService.addListener(_onNotificationCountChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationCountChanged);
    super.dispose();
  }

  void _onNotificationCountChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.customCount ?? _notificationService.unreadCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: count > 9 ? 6 : 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: widget.badgeColor ?? Color(0xffEE2417),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: BoxConstraints(
                minWidth: widget.badgeSize ?? 20,
                minHeight: widget.badgeSize ?? 20,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: widget.textColor ?? Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

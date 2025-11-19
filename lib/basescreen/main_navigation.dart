import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siren24/basescreen/home_screen.dart';
import 'package:siren24/basescreen/emergency_fab.dart';
import 'package:siren24/profile/history.dart';
import 'package:siren24/profile/notification.dart';
import 'package:siren24/profile/my_profile.dart';
import 'package:siren24/services/notification_counter_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);
  static String id = 'main_navigation';

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final NotificationCounterService _notificationService =
      NotificationCounterService();

  final List<Widget> _pages = [
    HomeScreenContent(), // Home screen without scaffold
    History(), // Booking history
    Notifications(), // Notifications
    MyProfile(), // User profile
  ];

  @override
  void initState() {
    super.initState();
    _notificationService.initializeCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: _currentIndex == 0 ? EmergencyFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  activeIcon: Icons.history,
                  label: 'History',
                  index: 1,
                ),
                // Space for FAB
                SizedBox(width: 40),
                _buildNavItemWithBadge(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Alerts',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xffEE2417).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Color(0xffEE2417) : Colors.grey.shade600,
                size: 24,
              ),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Color(0xffEE2417) : Colors.grey.shade600,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();

        // Mark notifications as read when opening notifications tab
        if (index == 2) {
          _notificationService.markAllAsRead();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xffEE2417).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: NotificationBadgeWidget(
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? Color(0xffEE2417) : Colors.grey.shade600,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Color(0xffEE2417) : Colors.grey.shade600,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper for HomeScreen content without Scaffold
class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(showScaffold: false);
  }
}

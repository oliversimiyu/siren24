import 'package:flutter/material.dart';
import 'package:siren24/basescreen/main_navigation.dart';
import 'package:siren24/profile/history.dart';
import 'package:siren24/profile/notification.dart';
import 'package:siren24/profile/my_profile.dart';
import 'package:siren24/profile/settings.dart';
import 'package:siren24/profile/inviteFriends.dart';
import 'package:siren24/signup/signin.dart';
import 'package:siren24/services/user_storage.dart';
import 'package:siren24/state/api_calling.dart';

class QuickNavigationDrawer extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userEmail;
  final String profilePicUrl;

  const QuickNavigationDrawer({
    Key? key,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.profilePicUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4C6EE5),
                    Color(0xFF6C7CE5),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: profilePicUrl.isNotEmpty
                                ? NetworkImage(profilePicUrl)
                                : null,
                            child: profilePicUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 35,
                                    color: Colors.grey.shade600,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (userPhone.isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(
                                  userPhone,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              if (userEmail.isNotEmpty) ...[
                                SizedBox(height: 2),
                                Text(
                                  userEmail,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, MainNavigation.id);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history,
                    title: 'Ride History',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, History.id);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Notifications.id);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MyProfile.id);
                    },
                  ),
                  Divider(color: Colors.grey.shade200),
                  _buildDrawerItem(
                    context,
                    icon: Icons.phone,
                    title: 'Emergency Hotline',
                    subtitle: 'Call 999 for immediate help',
                    color: Color(0xffEE2417),
                    onTap: () {
                      Navigator.pop(context);
                      ApiCaller().launchPhoneDialer('999');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.support_agent,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      ApiCaller().launchPhoneDialer('9718459379');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.share,
                    title: 'Invite Friends',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, InviteFriends.id);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Settings.id);
                    },
                  ),
                ],
              ),
            ),

            // Logout Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red.shade400,
                onTap: () async {
                  _showLogoutConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    final itemColor = color ?? Colors.grey.shade700;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: itemColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: itemColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: itemColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: itemColor.withOpacity(0.7),
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear session data while preserving registered users
              await UserStorageService.clearSessionData();

              // Navigate back to sign in page
              Navigator.pushNamedAndRemoveUntil(
                  context, Sign_in.id, (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffEE2417),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Logout',
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
}

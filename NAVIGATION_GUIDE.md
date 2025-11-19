# Bottom Navigation Implementation Guide

## Overview
This implementation provides a modern, feature-rich bottom navigation system for the Siren24 ambulance booking app with the following features:

- **Clean Material Design 3 inspired UI**
- **Emergency FAB (Floating Action Button) integration**
- **Notification badges with real-time updates** 
- **Smooth animations and haptic feedback**
- **Consistent navigation patterns**
- **Quick emergency access**

## Components

### 1. MainNavigation (`lib/basescreen/main_navigation.dart`)
The main navigation controller that manages:
- **5 navigation tabs**: Home, History, Alerts, Profile
- **Emergency FAB** positioned in center for quick access
- **IndexedStack** for efficient page management
- **Notification badges** on the alerts tab

### 2. EmergencyFAB (`lib/basescreen/emergency_fab.dart`)
A prominent emergency button that provides:
- **Quick access to emergency services**
- **Animated interactions with scale and rotation**
- **Emergency options bottom sheet**
- **Direct emergency hotline calling**

### 3. Navigation Service (`lib/services/navigation_service.dart`)
Centralized navigation management with:
- **Global navigation context**
- **Utility methods for common navigation patterns**
- **Built-in notification system (SnackBar, Dialogs)**
- **Loading states management**

### 4. Notification Counter Service (`lib/services/notification_counter_service.dart`)
Real-time notification badge management:
- **Persistent notification count storage**
- **Real-time updates using ChangeNotifier**
- **Badge widget for any UI component**
- **Automatic count management**

### 5. Custom App Bar (`lib/basescreen/custom_app_bar.dart`)
Reusable app bar components:
- **StandardAppBar**: Clean modern design
- **GradientAppBar**: Branded gradient background
- **NotificationBadge**: Reusable badge component

### 6. Quick Navigation Drawer (`lib/basescreen/quick_navigation_drawer.dart`)
Modern side navigation with:
- **User profile display**
- **Quick access to all app sections**
- **Emergency options**
- **Logout confirmation**

## Usage

### Setting Up Navigation

1. **In your main app**, ensure `MainNavigation` is properly registered:

```dart
// main.dart
routes: {
  MainNavigation.id: (context) => const MainNavigation(),
  // ... other routes
}
```

2. **Navigate to main navigation** after login:

```dart
Navigator.pushReplacementNamed(context, MainNavigation.id);
```

### Using Navigation Service

```dart
// Import the service
import 'package:siren24/services/navigation_service.dart';

// Navigate to a screen
NavigationService().navigateTo('/profile');

// Show success message
NavigationService().showSuccess('Profile updated successfully!');

// Show loading
NavigationService().showLoadingDialog();
NavigationService().hideLoadingDialog();

// Show confirmation
bool? confirmed = await NavigationService().showConfirmationDialog(
  title: 'Delete Account',
  message: 'Are you sure you want to delete your account?',
);
```

### Managing Notification Badges

```dart
// Import the service
import 'package:siren24/services/notification_counter_service.dart';

// Add new notification
NotificationCounterService().addNotification();

// Mark as read
NotificationCounterService().markAsRead();

// Mark all as read
NotificationCounterService().markAllAsRead();

// Use badge widget
NotificationBadgeWidget(
  child: Icon(Icons.notifications),
  customCount: 5, // Optional custom count
)
```

### Using Custom App Bars

```dart
// Standard app bar
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      title: 'My Profile',
      actions: [
        NotificationBadge(
          icon: Icons.notifications,
          count: 3,
          onTap: () => Navigator.pushNamed(context, Notifications.id),
        ),
      ],
    ),
    body: YourContent(),
  );
}

// Gradient app bar
appBar: GradientAppBar(
  title: 'Emergency Services',
  gradientColors: [Color(0xffEE2417), Color(0xffFF4136)],
)
```

## Navigation Flow

### User Journey
1. **Splash Screen** → **Onboarding** → **Login/Registration**
2. **MainNavigation** (Primary interface)
   - **Home Tab**: Map, booking, quick actions
   - **History Tab**: Past rides and bookings
   - **Alerts Tab**: Notifications with badge counter
   - **Profile Tab**: User settings and account
   - **Emergency FAB**: Quick emergency access

### Tab Navigation
- **Home (Index 0)**: Main map interface with booking
- **History (Index 1)**: Ride history and past bookings
- **Alerts (Index 2)**: Notifications with auto-badge clearing
- **Profile (Index 3)**: User profile and settings

### Emergency Access
- **FAB Tap**: Opens emergency options bottom sheet
- **Emergency Hotline**: Direct call to 999
- **Support Center**: Direct call to support
- **Emergency Booking**: Quick ambulance booking

## Customization

### Colors
Primary colors used in navigation:
- **Primary Red**: `Color(0xffEE2417)` - Emergency, active states
- **Primary Blue**: `Color(0xFF4C6EE5)` - Secondary actions, gradients
- **Grey Shades**: Various grey tones for inactive states

### Animation Timings
- **Tab switching**: 200ms ease curves
- **FAB animations**: 300ms elastic curves
- **Badge appearances**: Instant with smooth color transitions

### Responsive Design
- **Adaptive padding**: Responds to device safe areas
- **Scalable icons**: 24px standard with consistent sizing
- **Touch targets**: Minimum 44px for accessibility

## Best Practices

### Navigation Patterns
1. **Use IndexedStack** for persistent state across tabs
2. **Implement proper back button handling**
3. **Clear notification badges when appropriate**
4. **Provide haptic feedback for interactions**

### Performance
1. **Lazy load heavy screens**
2. **Use const constructors where possible**
3. **Dispose of animation controllers properly**
4. **Cache navigation states efficiently**

### Accessibility
1. **Proper semantic labels** for screen readers
2. **Sufficient touch target sizes** (44px minimum)
3. **High contrast colors** for visibility
4. **Haptic feedback** for interaction confirmation

## Emergency Features

### Emergency FAB
- **Always visible on home screen**
- **Prominent red color with gradient**
- **Animated feedback on press**
- **Direct access to emergency services**

### Emergency Options
1. **Emergency Ambulance**: Immediate booking with priority
2. **Emergency Hotline**: Direct dial to 999
3. **Support Center**: Contact app support team

### Safety Features
- **One-tap emergency calling**
- **Visible emergency access from home**
- **Quick emergency booking flow**
- **24/7 support access**

## Testing Navigation

### Unit Testing
- Test navigation service methods
- Test notification counter logic
- Test badge display logic

### Widget Testing
- Test tab switching functionality
- Test FAB interactions
- Test badge visibility states

### Integration Testing
- Test complete navigation flows
- Test emergency scenarios
- Test notification badge updates

## Troubleshooting

### Common Issues

1. **Navigation not working**
   - Ensure routes are properly registered in main.dart
   - Check NavigationService initialization

2. **Badges not updating**
   - Verify NotificationCounterService is initialized
   - Check SharedPreferences permissions

3. **FAB not showing**
   - Ensure EmergencyFAB is only shown on home tab
   - Check FloatingActionButtonLocation settings

4. **Animations stuttering**
   - Use const constructors where possible
   - Dispose animation controllers properly

### Debug Tips
- Use Flutter Inspector to check widget tree
- Monitor navigation stack with debugPrint
- Test on different screen sizes
- Verify color contrast ratios

## Future Enhancements

### Planned Features
1. **Tab badges for other screens** (History, Profile)
2. **Customizable tab order** based on user preferences
3. **Dark mode support** with theme switching
4. **Advanced emergency features** (location sharing, medical info)
5. **Push notification integration** with real-time badge updates

### Performance Optimizations
1. **Preload frequently used screens**
2. **Image caching for avatars and icons**
3. **Optimize animation performance**
4. **Reduce widget rebuilds with better state management**

This implementation provides a solid foundation for navigation that can be extended and customized as the app grows.
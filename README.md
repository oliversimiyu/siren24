# Siren 24 - Emergency Ambulance Booking App

Siren 24 is a comprehensive Flutter-based mobile application designed for emergency ambulance booking and medical transportation services. The app provides real-time ambulance booking, driver tracking, payment processing, and complete ride management with an intuitive user interface.

## 🚑 Project Overview

Siren 24 enables users to quickly book ambulances for medical emergencies with both immediate and scheduled booking options. The app features real-time notifications, comprehensive ride history, multiple payment methods, and a complete driver management system.

## 🎬 Demo

### App Demo Video

https://user-images.githubusercontent.com/75077531/193422846-52b3a45e-1944-408e-b8c5-fe84afa91dea.mp4

## ✨ Key Features

### 📱 **Core Functionality**
- **Immediate Booking**: Book ambulances instantly for emergency situations
- **Scheduled Booking**: Schedule ambulances for planned medical appointments
- **Real-time Location Services**: GPS-based location detection and routing
- **Driver Assignment**: Automatic driver allocation with vehicle details
- **Live Tracking**: Real-time ambulance tracking and ETA updates
- **Multi-platform Support**: Available for both Android and iOS

### 🔔 **Notification System**
- **Real-time Alerts**: Instant notifications for all ride events
- **Ride Status Updates**: Booking confirmation, driver assignment, arrival alerts
- **Payment Notifications**: Success/failure confirmations for all transactions
- **Smart Categorization**: Color-coded notifications by event type
- **Persistent Storage**: Notification history with offline access

### 📊 **Ride Management**
- **Comprehensive History**: Complete log of all rides (immediate and scheduled)
- **Detailed Records**: Source/destination, fare breakdown, driver information
- **Status Tracking**: Real-time ride status updates (booked, in-progress, completed)
- **Local Storage**: Offline-first approach with SharedPreferences integration

### 💳 **Payment Integration**
- **Multiple Payment Methods**: 
  - Online payments via Razorpay integration
  - Cash payment options
  - Payment failure handling
- **Fare Calculation**: Dynamic pricing with transparent fare breakdown
- **Payment Confirmations**: Real-time payment status updates

### 👤 **User Experience**
- **Modern UI/UX**: Clean, intuitive design with Material Design principles
- **Accessibility**: User-friendly interface for emergency situations
- **Profile Management**: User registration, authentication, and profile updates
- **Settings & Preferences**: Customizable app settings and notifications

## 🛠 Implementation Details

### **Architecture**
- **Framework**: Flutter SDK with Dart programming language
- **State Management**: Global state management with custom globals
- **Local Storage**: SharedPreferences for offline data persistence
- **Navigation**: Named route navigation with bottom sheets and modal dialogs

### **Key Services**
- **RideNotificationService**: Comprehensive notification management system
- **RideHistoryService**: Local ride data storage and retrieval
- **UserStorageService**: User authentication and profile management
- **LocationServices**: GPS integration with geocoding capabilities

### **Database & Storage**
- **Local Storage**: SharedPreferences for user data, ride history, and notifications
- **Mock API Integration**: Simulated backend services for demo functionality
- **Data Models**: Structured models for rides, users, payments, and notifications

### **External Integrations**
- **Google Maps**: Location services, mapping, and route optimization
- **Razorpay**: Secure payment processing
- **Firebase**: Push notifications and cloud messaging
- **Awesome Notifications**: Local notification management

## 🎯 Functionality Breakdown

### **Booking Flow**
1. **Location Selection**: GPS-based current location with destination selection
2. **Ambulance Selection**: Choose from available ambulance types and facilities
3. **Fare Calculation**: Transparent pricing with service breakdown
4. **Booking Confirmation**: Immediate or scheduled booking options
5. **Driver Assignment**: Real-time driver allocation with vehicle details
6. **Live Updates**: Continuous status updates throughout the journey

### **Notification Events**
- **Ride Booked**: Confirmation of successful booking
- **Driver Assigned**: Driver and vehicle information
- **Driver Arrived**: Pickup location arrival alert
- **Ride Started**: Journey commencement notification
- **Ride Completed**: Destination reached confirmation
- **Payment Success/Failure**: Transaction status updates
- **Ride Cancelled**: Cancellation confirmations with reasons
- **Ride Reminders**: Scheduled ride alerts

### **Payment Processing**
- **Fare Display**: Itemized fare breakdown (ambulance service, additional facilities)
- **Payment Options**: Online (Razorpay) and cash payment methods
- **Transaction Security**: Secure payment processing with error handling
- **Payment History**: Complete transaction records with receipts

### **History & Analytics**
- **Ride Records**: Complete journey logs with timestamps
- **Payment Tracking**: Transaction history with status indicators
- **Driver Ratings**: Post-ride rating and feedback system
- **Usage Analytics**: Ride patterns and frequency tracking

## 🔧 Technical Specifications

### **Mobile Platform Support**
- **Android**: API Level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Cross-platform**: Single codebase for both platforms

### **Performance Features**
- **Offline Capability**: Core functionality available without internet
- **Fast Loading**: Optimized UI with lazy loading and caching
- **Battery Optimization**: Efficient location services and background processing
- **Memory Management**: Optimal resource utilization for smooth performance

### **Security & Privacy**
- **Data Encryption**: Secure local data storage
- **Privacy Protection**: Minimal data collection with user consent
- **Secure Payments**: PCI-compliant payment processing
- **Authentication**: Secure user registration and login system

## 🎨 User Interface

### **Design System**
- **Color Scheme**: Primary blue (#4C6EE5) with accessibility-focused contrast
- **Typography**: Roboto font family with clear hierarchy
- **Iconography**: Material Design icons with custom ambulance-specific icons
- **Responsive Design**: Adaptive layouts for different screen sizes

### **User Experience**
- **Intuitive Navigation**: Bottom sheets, modals, and seamless transitions
- **Emergency-focused**: Large buttons and clear call-to-action elements
- **Accessibility**: Screen reader support and high contrast options
- **Multilingual Ready**: Internationalization support structure

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code with Flutter extensions
- Git for version control

### **Installation**
```bash
# Clone the repository
git clone https://github.com/oliversimiyu/siren24.git

# Navigate to project directory
cd siren24

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### **Configuration**
1. Set up Google Maps API keys in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`
2. Configure Razorpay credentials in `lib/payments/payment.dart`
3. Set up Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS)

## 📱 Demo & Testing

The application includes comprehensive mock services for demonstration purposes, allowing full functionality testing without backend dependencies. All core features including booking, notifications, payments, and history are fully functional in demo mode.

## 🤝 Contributing

We welcome contributions to improve Siren 24. Please read our contributing guidelines and submit pull requests for any enhancements.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For emergency services, always call your local emergency number. This app is designed to complement, not replace, traditional emergency services.

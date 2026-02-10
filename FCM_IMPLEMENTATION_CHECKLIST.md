# Firebase Cloud Messaging - Implementation Checklist

**Verification Guide for FCM Integration**  
**Last Updated:** February 10, 2026

---

## 🔍 Pre-Implementation Verification

### Firebase Project Setup
- [ ] Firebase project created in Google Cloud Console
- [ ] Firebase Messaging service enabled
- [ ] Billing enabled (FCM is free but requires billing account)
- [ ] Project is linked to your Flutter app
- [ ] `google-services.json` downloaded (Android)
- [ ] `GoogleService-Info.plist` downloaded (iOS)

### Development Environment
- [ ] Flutter SDK version 3.0+ installed
- [ ] Xcode 13+ (for iOS development)
- [ ] Android Studio 2021.3+ or equivalent
- [ ] At least one physical device for testing (iOS or Android)
- [ ] Device connected with USB debugging enabled

---

## 📦 Dependency Installation

### Step 1: Add Dependencies
```bash
# Navigate to project directory
cd your_flutter_project

# Add dependencies
flutter pub add firebase_core firebase_messaging flutter_local_notifications
```

### Step 2: Verify pubspec.yaml
- [ ] `firebase_core: ^2.24.0` (or latest)
- [ ] `firebase_messaging: ^14.7.0` (or latest)
- [ ] `flutter_local_notifications: ^15.1.0` (optional but recommended)
- [ ] `cloud_firestore: ^latest` (if using token storage)
- [ ] `firebase_auth: ^latest` (if using user authentication)

### Step 3: Install and Check
```bash
flutter pub get
flutter pub list | grep firebase
```

Verify output shows all three packages.

---

## 🛠️ Platform-Specific Setup

### Android Configuration

#### Step 1: Verify google-services.json
- [ ] File placed at `android/app/google-services.json`
- [ ] Contains correct `package_name`
- [ ] Contains Firebase credentials for Android app

**Location Check:**
```bash
# Windows/PowerShell
Test-Path "android/app/google-services.json"

# Should output: True
```

#### Step 2: Check build.gradle Files

**File: `android/build.gradle`**
```gradle
buildscript {
  dependencies {
    // Should contain:
    classpath 'com.google.gms:google-services:4.3.15'
  }
}
```
- [ ] Google Services gradle plugin added
- [ ] Version is 4.3.15 or higher

**File: `android/app/build.gradle`**
```gradle
plugins {
  id 'com.android.application'
  id 'com.google.gms.google-services'  // Should be present
}
```
- [ ] Google Services plugin applied
- [ ] FCM dependency in dependencies section

#### Step 3: Android Manifest Check

**File: `android/app/src/main/AndroidManifest.xml`**

Required permissions:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```
- [ ] `INTERNET` permission present
- [ ] `ACCESS_NETWORK_STATE` permission present

### iOS Configuration

#### Step 1: Verify GoogleService-Info.plist
- [ ] File placed at `ios/Runner/GoogleService-Info.plist`
- [ ] File added to Xcode project (not just filesystem)
- [ ] File targeted to Runner app

**Verification in Xcode:**
```
Runner
 └─ GoogleService-Info.plist ✅ (Check "Runner" target is checked)
```

#### Step 2: Check Podfile

**File: `ios/Podfile`**
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_post_install(installer, target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_NOTIFICATIONS=1',
      ]
    end
  end
end
```
- [ ] Podfile properly configured
- [ ] iOS deployment target is 11.0+

#### Step 3: Info.plist Configuration

**File: `ios/Runner/Info.plist`**

Add notification permissions:
```xml
<key>UIUserInterfaceStyle</key>
<string>Light</string>
<!-- Add after this key: -->

<key>com.apple.developer.usernotifications.filtering</key>
<true/>
```
- [ ] Info.plist edited correctly
- [ ] No syntax errors in plist

#### Step 4: Xcode Capabilities

In Xcode:
1. Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
2. Select Runner project
3. Select Runner target
4. Go to Signing & Capabilities tab
5. Add "Push Notifications" capability
6. [ ] Push Notifications capability visible

---

## 💻 Code Implementation

### Step 1: Firebase Initialization

**File: `lib/main.dart`**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

Verification:
```bash
dart analyze lib/main.dart
```
- [ ] No errors in main.dart
- [ ] Firebase import resolved
- [ ] firebase_options.dart exists

### Step 2: Create NotificationService

**File: `lib/services/notification_service.dart`**

Check file contains:
- [ ] `NotificationService` class definition
- [ ] `initialize()` method
- [ ] `requestNotificationPermissions()` method
- [ ] `getDeviceToken()` method
- [ ] `setupMessageHandlers()` method
- [ ] Foreground message handler
- [ ] Background message handler
- [ ] Terminated state handler

### Step 3: Initialize in App

Verify initialization call:
```dart
void main() async {
  // ... Firebase init ...
  
  // After Firebase.initializeApp():
  await NotificationService().initialize();
  
  runApp(const MyApp());
}
```
- [ ] NotificationService initialized
- [ ] Called after Firebase.initializeApp()
- [ ] Called before runApp()

### Step 4: Verify Imports

Check all imports resolve:
```bash
flutter pub get
flutter analyze
```
- [ ] No import errors
- [ ] All dependencies found
- [ ] No unused imports

---

## 🔑 Firebase Configuration Verification

### Step 1: Firebase Console Check

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Project Settings** → **Your apps**

Verify:
- [ ] Your Flutter app listed under "Android"
- [ ] Your Flutter app listed under "iOS"
- [ ] google-services.json available for download
- [ ] GoogleService-Info.plist available for download

### Step 2: Cloud Messaging Service

1. From Firebase Console home
2. Scroll down to find "Cloud Messaging"
3. Click on it

Verify:
- [ ] Cloud Messaging service enabled
- [ ] API shows as "ENABLED"
- [ ] No errors or warnings

### Step 3: Firestore Rules (If Using Token Storage)

If storing tokens in Firestore:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /fcmToken {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```
- [ ] Firestore rules allow user to update their document
- [ ] Rules tested in Firestore console

---

## ✅ Testing Verification

### Test 1: App Launch
```bash
flutter run
```
- [ ] App launches without errors
- [ ] No FCM-related crash logs
- [ ] Permission prompt appears (might need dismiss/allow)

### Test 2: Check Device Token

Add debugging to NotificationService:
```dart
Future<void> _getToken() async {
  String? token = await _messaging.getToken();
  print('🔑 Device Token: $token');
  if (token == null) {
    print('❌ Failed to get token');
  } else {
    print('✅ Token obtained successfully');
  }
}
```

Run app and check logs:
```bash
flutter logs | grep "Device Token"
```
- [ ] Token printed in logs
- [ ] Token is not null
- [ ] Token looks valid (long alphanumeric string)

### Test 3: Permissions

Check logs for permission status:
```bash
flutter logs | grep "Notification permission"
```
- [ ] Permission requested message appears
- [ ] Status shows "granted" or "provisional"

**On device:**
- [ ] Permission prompt shown to user
- [ ] User can accept or deny
- [ ] App behavior correct in both cases

### Test 4: Message Listeners

Add debugging to message handlers:
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('📬 FOREGROUND: ${message.notification?.title}');
});

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('📨 OPENED: ${message.notification?.title}');
});
```

- [ ] Foreground handler logs visible when message received
- [ ] Background handler logs visible when notification tapped

### Test 5: Firebase Console Test

1. Open Firebase Console
2. Go to **Messaging** → **Cloud Messaging**
3. Click **Send your first message**

Fill in:
- [ ] Title: "Test Notification"
- [ ] Body: "This is a test"
- [ ] Target: Select your app and device

Send:
- [ ] Notification appears on device
- [ ] Title and body match what was sent
- [ ] Device receives notification within 10 seconds

### Test 6: Foreground State Test

1. Keep app open
2. Send test notification from Firebase Console
3. Check logs and on-screen display

- [ ] Foreground message handler called
- [ ] Logs show message received
- [ ] Visual indicator on device (if implemented)

### Test 7: Background State Test

1. Send notification from Firebase Console
2. App is minimized (running in background)
3. Tap notification

- [ ] Notification appears in notification tray
- [ ] App comes to foreground on tap
- [ ] Background handler called
- [ ] Navigation logic executes

### Test 8: Terminated State Test

1. Completely close the app (kill it)
2. Send notification from Firebase Console
3. Tap notification

- [ ] Notification appears in notification tray
- [ ] App launches from notification tap
- [ ] Correct screen displayed
- [ ] No crashes or errors

---

## 🔐 Security Verification

### Token Security
- [ ] Tokens never logged with sensitive data
- [ ] Tokens stored securely in Firestore
- [ ] User authentication required before token save
- [ ] Tokens cleared on logout

### Message Validation
```dart
// Example: Validate sender
if (message.from == null || !message.from!.startsWith('123456789:')) {
  print('Invalid sender');
  return;
}
```
- [ ] Message validation implemented
- [ ] Only authorized senders can trigger navigation
- [ ] Invalid messages logged and ignored

### Permissions
- [ ] User prompted for permission
- [ ] App respects denial
- [ ] No crash if permission denied

---

## 📊 Platform-Specific Testing

### Android Testing
```bash
# Run on Android device
flutter run -d android
```

Checklist:
- [ ] App launches on Android device
- [ ] Token obtained successfully
- [ ] Foreground notification shows
- [ ] Background notification works
- [ ] Terminated state notification works
- [ ] Navigation from notification works

### iOS Testing
```bash
# Run on iOS device
flutter run -d ios
```

Checklist:
- [ ] App launches on iOS device
- [ ] Permission prompt shown
- [ ] Token obtained after permission granted
- [ ] Foreground notification handling
- [ ] Background notification works
- [ ] Terminated state notification works
- [ ] **Device only** (simulator has limitations)

---

## 🐛 Debugging Verification

### Enable Debug Logging
```dart
// In NotificationService.initialize()
import 'package:firebase_core/firebase_core.dart';

// Enable Firebase logging
FirebaseMessaging.instance.onTokenRefresh.listen((token) {
  print('Token refreshed: $token');
}).onError((err) {
  print('Token error: $err');
});
```

- [ ] Debug output visible in console
- [ ] No error messages
- [ ] Token refresh detected

### Check Firestore Storage (If Implemented)
```bash
# In Firebase Console:
# Firestore Database → users → [userId] → fcmToken
```
- [ ] User document exists
- [ ] fcmToken field populated
- [ ] Token matches device token in logs

---

## 🚀 Pre-Deployment Checklist

### Code Quality
- [ ] No compilation errors
- [ ] No analysis warnings: `flutter analyze`
- [ ] Code formatted: `flutter format .`
- [ ] All tests pass: `flutter test`

### Testing Complete
- [ ] Foreground notification tested
- [ ] Background notification tested
- [ ] Terminated state tested
- [ ] Android device tested
- [ ] iOS device tested
- [ ] Token storage verified
- [ ] Permissions handled correctly

### Documentation
- [ ] FCM_README.md reviewed
- [ ] FCM_QUICK_START.md reviewed
- [ ] Code comments added
- [ ] Team trained on testing

### Firebase Setup
- [ ] APNs certificate configured (iOS)
- [ ] google-services.json current
- [ ] GoogleService-Info.plist current
- [ ] Firestore rules configured
- [ ] Cloud Messaging enabled

### Performance
- [ ] App startup time acceptable
- [ ] Memory usage reasonable
- [ ] Battery impact minimal
- [ ] Network usage efficient

---

## 📋 Rollback Plan

If issues arise:
1. [ ] Disable NotificationService initialization
2. [ ] Comment out `NotificationService().initialize()`
3. [ ] Remove firebase_messaging from pubspec.yaml
4. [ ] Run `flutter pub get`
5. [ ] Test app launches successfully

---

## 📞 Common Issues Reference

| Issue | Check | Fix |
|-------|-------|-----|
| Token is null | Firebase initialized? | Check firebase_options.dart |
| No notifications | Permissions granted? | Grant in settings |
| iOS no notifications | APNs cert uploaded? | Upload in Firebase Console |
| Crashes on startup | google-services.json? | Re-download and place in correct location |
| Background handler not called | Top-level function? | Must not be class method |

---

## ✅ Final Verification Checklist

- [ ] All pre-implementation checks passed
- [ ] All dependencies installed correctly
- [ ] Android configuration complete
- [ ] iOS configuration complete
- [ ] NotificationService implemented
- [ ] Firebase initialized in main.dart
- [ ] All tests passed (8 tests above)
- [ ] Firebase configuration verified
- [ ] Security measures in place
- [ ] Code quality checks passed
- [ ] Team trained
- [ ] Documentation reviewed
- [ ] Ready for production deployment

---

## 🎉 Deployment Ready!

When all checkboxes are complete, your FCM integration is ready for production:

```bash
# Build release version
flutter build apk           # Android
flutter build ios           # iOS
flutter build web          # Web (if applicable)
```

---

**Verification Status:** Ready to Deploy ✅  
**Last Checked:** February 10, 2026  
**Next Review:** Post-deployment check

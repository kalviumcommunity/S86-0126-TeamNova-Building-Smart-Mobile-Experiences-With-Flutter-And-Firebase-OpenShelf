# Firebase Cloud Messaging - Quick Start Guide

**Get up and running with FCM in 5 minutes** ⚡

---

## 📦 Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^15.1.0  # Optional: for rich notifications
```

Run:
```bash
flutter pub get
```

---

## 🚀 Step 2: Initialize Firebase & FCM

In `main.dart`:

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

---

## 📱 Step 3: Request Permissions

Create `lib/services/notification_service.dart`:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();
    
    // Get device token
    await _getToken();
    
    // Setup listeners
    await _setupListeners();
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    // Save token to Firestore for targeted messaging
  }

  Future<void> _setupListeners() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground: ${message.notification?.title}');
    });

    // Background message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened: ${message.notification?.title}');
    });

    // Terminated state
    RemoteMessage? initialMsg = await _messaging.getInitialMessage();
    if (initialMsg != null) {
      print('Launched from: ${initialMsg.notification?.title}');
    }
  }
}
```

---

## ✅ Step 4: Use in Your App

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize notifications
  await NotificationService().initialize();
  
  runApp(const MyApp());
}
```

---

## 🧪 Step 5: Test with Firebase Console

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project → **Messaging**
3. Click **Send your first message**
4. Enter title and body
5. Click **Send test message**
6. Select your app and device
7. ✅ Receive notification on your device!

---

## 🎯 Common Next Steps

### Save Token to Firestore
```dart
Future<void> saveTokenToFirestore(String token) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({'fcmToken': token}, SetOptions(merge: true));
  }
}
```

### Send from Backend (Node.js)
```javascript
const admin = require('firebase-admin');

admin.messaging().send({
  token: userFcmToken,
  notification: {
    title: 'Hello!',
    body: 'Welcome back to OpenShelf',
  },
  data: {
    orderId: '12345',
  },
});
```

### Subscribe to Topics
```dart
// Subscribe users
await FirebaseMessaging.instance.subscribeToTopic('promotions');

// Backend sends to all subscribers
admin.messaging().send({
  topic: 'promotions',
  notification: { /* ... */ },
});
```

---

## 🐛 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| No notifications | Check permissions granted + Firebase enabled |
| Token is null | Restart app + check internet connection |
| iOS notifications not showing | Verify APNs certificate in Firebase Console |
| Background handler not called | Ensure handler is top-level function (not class method) |

---

## 📚 Learn More

- [Full FCM Guide](./FCM_README.md)
- [Firebase Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Package](https://pub.dev/packages/firebase_messaging)

---

**Ready to send notifications? Let's go! 🚀**

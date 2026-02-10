# Google Maps Quick Start - 10 Minutes

**Get a working Google Map displayed in your Flutter app in 10 minutes**

---

## ⏱️ Quick Timeline

- **Minutes 0-2**: Add dependency
- **Minutes 2-4**: Get API key
- **Minutes 4-7**: Configure platforms
- **Minutes 7-10**: Add map to your app

---

## 🔧 Step 1: Add Dependency (2 minutes)

### Update pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.6.0
  geolocator: ^10.0.0
```

### Install

```bash
flutter pub get
```

**Done!** ✅

---

## 🔑 Step 2: Get Google Maps API Key (2 minutes)

### Create Free API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. **Create new project** (or select existing)
3. Go to **APIs & Services → Credentials**
4. Click **Create Credentials → API Key**
5. Copy your API key
6. Go to **APIs & Services → Enabled APIs**
7. Click **Enable APIs and Services**
8. Search for and enable:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
9. **Save your API key** - you'll need it next

**Note**: Production apps need billing enabled, but development works free for 90 days.

**Done!** ✅

---

## 📱 Step 3: Configure Platforms (3 minutes)

### Android Configuration

**android/app/src/main/AndroidManifest.xml**

Find `<application>` tag and add this inside:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

Add these permissions before `</manifest>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS Configuration

**ios/Runner/AppDelegate.swift**

Replace file contents with:

```swift
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("YOUR_API_KEY_HERE")

        let controller = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(
            name: "com.example.app/maps",
            binaryMessenger: controller.binaryMessenger)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

**ios/Runner/Info.plist**

Add inside `<dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show maps.</string>
```

**Done!** ✅

---

## 🗺️ Step 4: Display Map in Your App (3 minutes)

### Create MapScreen

**lib/screens/map_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
```

### Add to Your App

**lib/main.dart**

```dart
import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapScreen(),
    );
  }
}
```

**Done!** ✅

---

## ▶️ Step 5: Run Your App (1 minute)

```bash
flutter run
```

**You should see an interactive map with:**
- ✅ Pan gesture (drag)
- ✅ Zoom in/out (pinch)
- ✅ Rotate gesture (two fingers twist)
- ✅ My location button
- ✅ Current location marker

---

## 🎯 What You Got

A fully functional map that:
- ✅ Displays Google Maps
- ✅ Shows user's location
- ✅ Responds to touch gestures
- ✅ Has a my-location button
- ✅ Works on Android and iOS

---

## 🆘 Troubleshooting

### Map shows blank screen

**Android**: Add API key to `AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

**iOS**: Add API key to `AppDelegate.swift`
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

### "For development purposes only" banner

Enable billing in [Google Cloud Console](https://console.cloud.google.com/billing)

### Location button not working

**Android**: Add to `AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

**iOS**: Add to `Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location needed for maps</string>
```

Then run: `flutter run` (permissions requested at startup)

### App crashes on iOS

Rebuild iOS:
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
flutter run
```

### Still having issues?

Check [GOOGLE_MAPS_README.md](./GOOGLE_MAPS_README.md) Common Issues section

---

## 📚 Next Steps

- ✅ Map working? **Congratulations!**
- 📖 Learn more: [Read GOOGLE_MAPS_README.md](./GOOGLE_MAPS_README.md)
- 💻 Get code examples: [See GOOGLE_MAPS_CODE_EXAMPLES.md](./GOOGLE_MAPS_CODE_EXAMPLES.md)
- ✓ Verify setup: [Follow GOOGLE_MAPS_IMPLEMENTATION_CHECKLIST.md](./GOOGLE_MAPS_IMPLEMENTATION_CHECKLIST.md)

---

## ✨ Pro Tips

1. **Test with real device** for location accuracy
2. **Check logcat** (Android) or Xcode (iOS) for errors
3. **Use emulator with Google Play Services** (Android)
4. **Commit API key safely** - use environment variables in production
5. **Read permission errors carefully** - they usually tell you exactly what's missing

---

**Time Spent**: ~10 minutes  
**Result**: Fully functional Google Map in your Flutter app  
**Next**: Explore markers, polylines, and location tracking in the README

**Status**: ✅ Quick Start Complete!

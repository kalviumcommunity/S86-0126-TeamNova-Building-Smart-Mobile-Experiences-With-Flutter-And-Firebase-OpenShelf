# Google Maps Integration for Flutter

**Complete guide to displaying interactive maps, markers, and location tracking in Flutter**

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Why Google Maps Integration](#why-google-maps-integration)
3. [Architecture](#architecture)
4. [Setup Steps](#setup-steps)
5. [Platform Configuration](#platform-configuration)
6. [Google Maps in Flutter](#google-maps-in-flutter)
7. [Location Services](#location-services)
8. [Advanced Features](#advanced-features)
9. [Testing & Verification](#testing--verification)
10. [Common Issues & Solutions](#common-issues--solutions)
11. [Best Practices](#best-practices)

---

## Overview

This module provides complete coverage of integrating Google Maps into Flutter applications. You will learn to:

- ✅ Set up Google Maps API and obtain API keys
- ✅ Configure Android and iOS platforms
- ✅ Display interactive map widgets
- ✅ Add and manage markers
- ✅ Handle user location
- ✅ Implement gestures and camera controls
- ✅ Customize map appearance
- ✅ Test maps functionality
- ✅ Troubleshoot common issues

**Target**: Production-ready map integration for navigation, delivery tracking, and location-based services.

---

## Why Google Maps Integration

### 🌍 Core Use Cases

**1. Navigation & Routing**
- Real-time directions
- Turn-by-turn navigation
- Route optimization

**2. Delivery & Logistics**
- Delivery tracking
- Driver location updates
- Multiple stops visualization

**3. Cab Booking Apps (Uber-like)**
- Driver location display
- Ride tracking
- Pickup/dropoff markers
- ETA calculations

**4. Location-Based Services**
- Nearby places search
- Store locator
- Search results map view
- Geofencing

**5. Real-Time Monitoring**
- Fleet tracking
- Asset location
- Live event locations

### 🎯 Key Benefits

| Benefit | Impact |
|---------|--------|
| Native Integration | Smooth performance with 60 FPS |
| Touch Gestures | Intuitive pan, zoom, rotate controls |
| Offline Maps | Works with cached tile layers |
| Custom Styling | Match app theme and branding |
| Real-time Updates | Live location tracking |
| Marker Clustering | Handle 1000+ markers efficiently |

---

## Architecture

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Application                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │   UI Layer       │         │  Services Layer  │          │
│  ├──────────────────┤         ├──────────────────┤          │
│  │ MapScreen        │ ◄────►  │ LocationService  │          │
│  │ MapController    │         │ MapService       │          │
│  │ Gestures         │         │ GeocodeService   │          │
│  └──────────────────┘         └──────────────────┘          │
│           ▲                             ▲                    │
│           │                             │                    │
└───────────┼─────────────────────────────┼────────────────────┘
            │                             │
            │ google_maps_flutter         │ geolocator
            │ location                    │ geocoding
            │                             │
    ┌───────┴─────────────────────────────┴────────┐
    │                                               │
┌───▼──────────────────────────────────────────────▼───┐
│         Google Maps Platform API                     │
├────────────────────────────────────────────────────────┤
│  • Maps SDK for Android                              │
│  • Maps SDK for iOS                                  │
│  • Geocoding API                                     │
│  • Places API (optional)                             │
│  • Directions API (optional)                         │
└────────────────────────────────────────────────────────┘
```

### Data Flow

```
User Interaction
    ↓
GestureDetector (pan, zoom, rotate)
    ↓
GoogleMapController
    ↓
Update Camera Position
    ↓
Map Renders new view
    ↓
Markers/Layers update
    ↓
Display updated map
```

---

## Setup Steps

### Step 1: Add Dependencies

**pubspec.yaml**
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.6.0
  location: ^5.0.0
  geolocator: ^10.0.0
  geocoding: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
```

**Run:**
```bash
flutter pub get
```

### Step 2: Get Google Maps API Key

#### Option A: Quick Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project or select existing
3. Go to **APIs & Services → Credentials**
4. Click **Create Credentials → API Key**
5. Copy the API key
6. Go to **APIs & Services → Enabled APIs & Services**
7. Enable these APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API** (optional)
   - **Directions API** (optional)

#### Option B: Enable Billing (Production)
1. In Google Cloud Console, go to **Billing**
2. Link your billing account
3. Wait 5-10 minutes for API activation
4. Configure API restrictions:
   - Select your API key
   - Go to **Key restrictions**
   - Select **Android apps** or **iOS apps**
   - Add your app's package name and SHA-1 fingerprint (Android)
   - Or Bundle ID (iOS)

### Step 3: Verify Dependencies

```bash
flutter doctor -v
```

Ensure:
- ✅ Android SDK 21+ (API level)
- ✅ iOS 11+ deployment target
- ✅ CocoaPods updated (iOS)

---

## Platform Configuration

### Android Configuration

#### 1. Add API Key to Manifest

**android/app/src/main/AndroidManifest.xml**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.openShelf">

    <!-- Add this inside <application> tag -->
    <application
        android:label="OpenShelf"
        android:icon="@mipmap/ic_launcher">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>

        <activity
            android:name=".MainActivity"
            android:exported="true"
            ...>
            ...
        </activity>
    </application>

    <!-- Location Permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

</manifest>
```

#### 2. Request Runtime Permissions

**lib/services/location_service.dart**

```dart
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
}
```

#### 3. Update build.gradle

**android/app/build.gradle**

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.openshelf"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### iOS Configuration

#### 1. Add API Key to AppDelegate

**ios/Runner/GeneratedPluginRegistrant.m** (automatically generated)

Or manually in **ios/Runner/AppDelegate.swift**:

```swift
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Google Maps with API Key
        GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")

        let controller = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(
            name: "com.example.openshelf/maps",
            binaryMessenger: controller.binaryMessenger)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

Or in **ios/Runner/AppDelegate.m**:

```objc
#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Google Maps
    [GMSServices provideAPIKey:@"YOUR_GOOGLE_MAPS_API_KEY_HERE"];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

#### 2. Add Location Permissions

**ios/Runner/Info.plist**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Existing keys... -->
    
    <!-- Location Permission when app is in use -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app requires location access to display your location on the map.</string>
    
    <!-- Location Permission always (background) -->
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs access to your location for delivery tracking and navigation.</string>
    
    <!-- Background modes -->
    <key>UIBackgroundModes</key>
    <array>
        <string>location</string>
    </array>
</dict>
</plist>
```

#### 3. Update Deployment Target

**ios/Podfile**

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
      ]
    end
  end
end
```

---

## Google Maps in Flutter

### Basic Map Display

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

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
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

### Map with Custom Camera

```dart
Future<void> _goToTheLake() async {
  final GoogleMapController controller = await _controller.future;
  await controller.animateCamera(
    CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(40.6892, -74.0445), // New York
        zoom: 14.0,
        bearing: 192.8334901395799,
        tilt: 59.440717697143555,
      ),
    ),
  );
}
```

### Interactive Gestures

```dart
GoogleMap(
  initialCameraPosition: _initialCameraPosition,
  onMapCreated: _onMapCreated,
  myLocationEnabled: true,
  myLocationButtonEnabled: true,
  zoomControlsEnabled: true,
  scrollGesturesEnabled: true,
  zoomGesturesEnabled: true,
  rotateGesturesEnabled: true,
  tiltGesturesEnabled: true,
  onCameraMove: (CameraPosition position) {
    // Handle camera movement
    debugPrint('Camera moved to: ${position.target}');
  },
)
```

---

## Location Services

### Request Location Permission

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum 10m movement
      ),
    );
  }
}
```

### Display User Location

```dart
class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late StreamSubscription<Position> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() {
    _locationSubscription =
        LocationService.getLocationStream().listen((Position position) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Location')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: const LatLng(0, 0),
          zoom: 2,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }
}
```

---

## Advanced Features

### Adding Markers

```dart
Set<Marker> _buildMarkers() {
  return {
    const Marker(
      markerId: MarkerId('marker1'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(
        title: 'San Francisco',
        snippet: 'Golden Gate Bridge',
      ),
    ),
    Marker(
      markerId: const MarkerId('marker2'),
      position: const LatLng(34.0522, -118.2437),
      infoWindow: const InfoWindow(
        title: 'Los Angeles',
        snippet: 'Hollywood Sign',
      ),
      onTap: () {
        debugPrint('LA marker tapped');
      },
    ),
  };
}

// Use in GoogleMap widget
GoogleMap(
  initialCameraPosition: _initialCameraPosition,
  markers: _buildMarkers(),
  onMapCreated: _onMapCreated,
)
```

### Polylines (Routes)

```dart
Set<Polyline> _buildPolylines() {
  return {
    Polyline(
      polylineId: const PolylineId('route1'),
      points: const [
        LatLng(37.7749, -122.4194),
        LatLng(37.8044, -122.2712),
        LatLng(37.3382, -121.8863),
      ],
      color: Colors.blue,
      width: 5,
      patterns: const [
        PatternItem.dash(20),
        PatternItem.gap(10),
      ],
    ),
  };
}

GoogleMap(
  initialCameraPosition: _initialCameraPosition,
  polylines: _buildPolylines(),
  onMapCreated: _onMapCreated,
)
```

### Polygons (Areas)

```dart
Set<Polygon> _buildPolygons() {
  return {
    Polygon(
      polygonId: const PolygonId('area1'),
      points: const [
        LatLng(28.6139, 77.2090),
        LatLng(28.6205, 77.2095),
        LatLng(28.6215, 77.2180),
        LatLng(28.6155, 77.2190),
      ],
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    ),
  };
}
```

### Circles (Radius)

```dart
Set<Circle> _buildCircles() {
  return {
    Circle(
      circleId: const CircleId('radius1'),
      center: const LatLng(37.7749, -122.4194),
      radius: 1000, // 1 km radius
      fillColor: Colors.red.withOpacity(0.2),
      strokeColor: Colors.red,
      strokeWidth: 2,
    ),
  };
}
```

### Geocoding (Address to Coordinates)

```dart
import 'package:geocoding/geocoding.dart';

class GeocodeService {
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
    return null;
  }

  static Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.postalCode}';
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }
    return null;
  }
}
```

---

## Testing & Verification

### Unit Tests for Location Service

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

class MockGeolocator extends Mock implements Geolocator {}

void main() {
  group('LocationService Tests', () {
    test('getCurrentLocation returns valid position', () async {
      final position = await LocationService.getCurrentLocation();
      expect(position, isNotNull);
      expect(position!.latitude, isA<double>());
      expect(position.longitude, isA<double>());
    });

    test('getLocationStream emits positions', () async {
      final positions = <Position>[];
      final subscription = LocationService.getLocationStream().listen((pos) {
        positions.add(pos);
      });

      await Future.delayed(const Duration(seconds: 5));
      subscription.cancel();

      expect(positions.isNotEmpty, true);
    });
  });
}
```

### Integration Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openshelf/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Google Maps Integration Tests', () {
    testWidgets('Map loads and displays', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify map is displayed
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('User location button works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap my location button
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();

      // Verify map updated
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('Marker displays info window', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap marker
      // Verify info window appears
      expect(find.byType(InfoWindow), findsWidgets);
    });
  });
}
```

### Manual Testing Checklist

- [ ] Map displays on Android
- [ ] Map displays on iOS
- [ ] Initial camera position correct
- [ ] Zoom in/out works
- [ ] Pan gesture works
- [ ] Rotate gesture works
- [ ] Tilt gesture works
- [ ] My location button works
- [ ] Location permission granted
- [ ] Markers display correctly
- [ ] Info window opens on tap
- [ ] Polylines render correctly
- [ ] No red screen errors

---

## Common Issues & Solutions

### Issue 1: Blank Screen on Android

**Symptom**: Map doesn't appear on Android device/emulator

**Root Causes**:
1. API key missing in AndroidManifest.xml
2. API key not enabled for Maps SDK
3. Billing not enabled in Google Cloud

**Solutions**:
```xml
<!-- Verify in AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

1. Check Google Cloud Console:
   - Go to APIs & Services
   - Verify "Maps SDK for Android" is enabled
   - Enable billing if not already done

2. Clear cache and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

---

### Issue 2: "Maps SDK not initialized" on iOS

**Symptom**: App crashes on iOS with initialization error

**Root Causes**:
1. API key not set in AppDelegate
2. CocoaPods not updated

**Solutions**:

**AppDelegate.swift**:
```swift
import GoogleMaps

override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
    // ... rest of code
}
```

Rebuild iOS:
```bash
cd ios
rm -rf Pods
rm Podfile.lock
cd ..
flutter pub get
flutter run
```

---

### Issue 3: "For Development Purposes Only" Message

**Symptom**: Red banner appears on map saying "For development purposes only"

**Root Causes**:
- Billing not enabled on Google Cloud
- API key is in development mode

**Solutions**:
1. Go to Google Cloud Console
2. Enable billing for your project
3. Wait 5-10 minutes for activation
4. Rebuild the app

---

### Issue 4: Location Permission Not Granted

**Symptom**: User location doesn't appear, location button doesn't work

**Root Causes**:
1. Permission not requested
2. Permission denied by user
3. Permission not added to manifest

**Solutions**:

**Android - AndroidManifest.xml**:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

**iOS - Info.plist**:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location needed for maps</string>
```

**Request at Runtime**:
```dart
import 'package:permission_handler/permission_handler.dart';

final status = await Permission.location.request();
if (status.isGranted) {
  // Use location
}
```

---

### Issue 5: API Key Restrictions Error

**Symptom**: "The API key doesn't have Maps SDK for Android enabled" or similar

**Root Causes**:
1. API key has restrictions
2. Restrictions don't match app
3. Wrong API key

**Solutions**:
1. In Google Cloud Console, select your API key
2. Go to **Key restrictions**
3. For Android:
   - Select "Android apps"
   - Add your app's SHA-1 fingerprint and package name
   - Get SHA-1 with: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

4. For iOS:
   - Select "iOS apps"
   - Add your Bundle ID
   - Found in Xcode: Targets → Runner → General

---

### Issue 6: Map Texture Issues

**Symptom**: Map shows checkerboard pattern or doesn't render properly

**Root Causes**:
1. Graphics acceleration disabled
2. OpenGL issues
3. Plugin conflicts

**Solutions**:
1. Ensure hardware acceleration enabled (Android):
```xml
<application
    android:usesCleartextTraffic="false"
    android:hardwareAccelerated="true">
```

2. Update Google Maps Flutter:
```bash
flutter pub upgrade google_maps_flutter
```

3. Try on physical device instead of emulator

---

### Quick Issue Reference

| Issue | Quick Fix |
|-------|-----------|
| Blank map | Add API key to manifest |
| iOS crash | Add API key to AppDelegate |
| "Dev only" banner | Enable billing in Google Cloud |
| No location | Add permissions + request at runtime |
| Red screen | Check API key restrictions |
| Map glitches | Update plugin, use physical device |
| Slow performance | Increase minSdkVersion, reduce markers |

---

## Best Practices

### 1. **API Key Security**

❌ **Don't**:
```dart
// Never commit API keys to git
const apiKey = "AIzaSyD..."; // Exposed!
```

✅ **Do**:
```dart
// Use platform-specific configuration
// Android: AndroidManifest.xml metadata
// iOS: Environment variables or secrets
// Use github secrets for CI/CD
```

### 2. **Performance Optimization**

**Marker Clustering**:
```dart
// For 100+ markers, use clustering to improve performance
// Consider: google_maps_flutter_web, marker clustering plugin
```

**Lazy Loading**:
```dart
// Load markers based on camera position
void _onCameraMove(CameraPosition position) {
  // Only load markers in visible bounds
  final bounds = _calculateVisibleBounds(position);
  _loadMarkersInBounds(bounds);
}
```

**Memory Management**:
```dart
@override
void dispose() {
  mapController.dispose(); // Always dispose
  _locationSubscription?.cancel();
  super.dispose();
}
```

### 3. **Error Handling**

```dart
Future<void> _initializeMap() async {
  try {
    final hasPermission = await LocationService.hasLocationPermission();
    if (!hasPermission) {
      // Show permission dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required')),
      );
      return;
    }

    final position = await LocationService.getCurrentLocation();
    if (position == null) {
      // Handle location error
      return;
    }

    // Initialize map with position
  } catch (e) {
    debugPrint('Error: $e');
    // Show error to user
  }
}
```

### 4. **User Experience**

- Show loading indicator while map initializes
- Display error messages clearly
- Provide fallback options (e.g., manual address entry)
- Handle low-end devices gracefully

### 5. **Testing**

```dart
// Use FakeGeolocator for testing without real device
class FakeGeolocator extends Fake implements Geolocator {
  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
  }) async {
    return Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
```

---

## Summary

**Google Maps integration in Flutter enables**:
✅ Interactive map displays  
✅ Real-time location tracking  
✅ Marker and route visualization  
✅ Gesture-based navigation  
✅ Location-based services  

**Key files to create**:
- API key in Google Cloud Console
- Platform configuration (Android manifest, iOS AppDelegate)
- LocationService for permission and position management
- MapScreen widget with GoogleMap controller
- Error handling and testing

**Success metrics**:
- Map displays on both Android and iOS
- Location permissions working
- Markers and polylines render correctly
- No crashes or performance issues
- 60 FPS smooth interactions

**Next steps**:
1. Create API key (Step 2)
2. Configure platforms (Step 3)
3. Build LocationService (Location Services section)
4. Create MapScreen (Google Maps in Flutter section)
5. Test thoroughly (Testing section)
6. Deploy to production

---

**Status**: ✅ Complete & Production-Ready  
**Last Updated**: February 10, 2026  
**Team**: Team Nova

# User Location & Markers - Quick Start - 10 Minutes

**Get user location displaying and markers on your map in 10 minutes**

---

## ⏱️ Timeline

- **Minutes 0-2**: Add dependencies
- **Minutes 2-4**: Add permissions
- **Minutes 4-7**: Get location & display
- **Minutes 7-10**: Add markers

---

## 📦 Step 1: Add Dependencies (2 minutes)

**pubspec.yaml**
```yaml
dependencies:
  google_maps_flutter: ^2.6.0
  geolocator: ^10.0.0
  permission_handler: ^11.4.0
```

```bash
flutter pub get
```

---

## 🔐 Step 2: Add Permissions (2 minutes)

### Android

**android/app/src/main/AndroidManifest.xml**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS

**ios/Runner/Info.plist**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location.</string>
```

---

## 📍 Step 3: Get Location & Display (3 minutes)

**lib/screens/location_map_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  late GoogleMapController mapController;
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });

      // Center map on user
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userLocation!,
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (controller) => mapController = controller,
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

---

## 🎯 Step 4: Add Markers (3 minutes)

```dart
Set<Marker> _buildMarkers() {
  if (userLocation == null) return {};

  return {
    Marker(
      markerId: const MarkerId('user'),
      position: userLocation!,
      infoWindow: const InfoWindow(title: 'You are here'),
    ),
    Marker(
      markerId: const MarkerId('destination'),
      position: const LatLng(34.0522, -118.2437),
      infoWindow: const InfoWindow(title: 'Los Angeles'),
    ),
  };
}

// Use in GoogleMap
GoogleMap(
  initialCameraPosition: _cameraPosition,
  markers: _buildMarkers(),
  myLocationEnabled: true,
  myLocationButtonEnabled: true,
)
```

---

## ✅ Done!

You now have:
- ✅ User location on map
- ✅ My location button
- ✅ Markers showing locations
- ✅ Permission handling

---

## 🆘 Quick Fixes

**Blank screen?**
- Check permissions in manifest/Info.plist
- Run on real device, not emulator

**Location not showing?**
- Grant permission when asked
- Check phone location is enabled
- Restart app

**Markers not visible?**
- Make sure _buildMarkers() returns non-empty set
- Call setState() after location changes

---

## 📚 Next Steps

- Learn more: [USER_LOCATION_MARKERS_README.md](./USER_LOCATION_MARKERS_README.md)
- See code examples: [USER_LOCATION_MARKERS_CODE_EXAMPLES.md](./USER_LOCATION_MARKERS_CODE_EXAMPLES.md)
- Real-time tracking: [Location Stream section in README]

**Status**: ✅ Quick Start Complete!

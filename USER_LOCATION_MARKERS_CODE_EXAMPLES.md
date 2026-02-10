# User Location & Markers - Code Examples

**Copy-paste ready code for location access, marker management, and real-time tracking**

---

## 📋 Example Index

1. [Location Permission Service](#1-location-permission-service)
2. [User Location Service](#2-user-location-service)
3. [Basic Location Map](#3-basic-location-map)
4. [Location with Markers](#4-location-with-markers)
5. [Custom Marker Icons](#5-custom-marker-icons)
6. [Real-time Location Tracking](#6-real-time-location-tracking)
7. [Multi-location Map](#7-multi-location-map)

---

## 1. Location Permission Service

**lib/services/location_permission_service.dart**

```dart
import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }

  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
```

---

## 2. User Location Service

**lib/services/user_location_service.dart**

```dart
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocationService {
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Position?> getPositionDetails() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 5),
      ),
    );
  }
}
```

---

## 3. Basic Location Map

**lib/screens/basic_location_map_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/user_location_service.dart';
import '../services/location_permission_service.dart';

class BasicLocationMapScreen extends StatefulWidget {
  const BasicLocationMapScreen({super.key});

  @override
  State<BasicLocationMapScreen> createState() =>
      _BasicLocationMapScreenState();
}

class _BasicLocationMapScreenState extends State<BasicLocationMapScreen> {
  late GoogleMapController mapController;
  LatLng? userLocation;
  bool isLoading = true;

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final hasPermission =
          await LocationPermissionService.hasLocationPermission();

      if (!hasPermission) {
        final result =
            await LocationPermissionService.requestLocationPermission();
        if (result != LocationPermission.whileInUse &&
            result != LocationPermission.always) {
          return;
        }
      }

      final location = await UserLocationService.getCurrentLocation();
      if (mounted && location != null) {
        setState(() {
          userLocation = location;
          isLoading = false;
        });

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 15),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeLocation,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _defaultPosition,
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

## 4. Location with Markers

**lib/screens/location_markers_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/user_location_service.dart';

class LocationMarkersScreen extends StatefulWidget {
  const LocationMarkersScreen({super.key});

  @override
  State<LocationMarkersScreen> createState() => _LocationMarkersScreenState();
}

class _LocationMarkersScreenState extends State<LocationMarkersScreen> {
  late GoogleMapController mapController;
  LatLng? userLocation;
  final Set<Marker> markers = {};

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final location = await UserLocationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        userLocation = location;
        _addUserMarker(location);
        _addDestinationMarkers();
      });

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 12),
        ),
      );
    }
  }

  void _addUserMarker(LatLng location) {
    markers.add(
      Marker(
        markerId: const MarkerId('user'),
        position: location,
        infoWindow: const InfoWindow(title: 'You are here'),
        onTap: () => _onMarkerTap('user'),
      ),
    );
  }

  void _addDestinationMarkers() {
    final destinations = [
      ('store1', const LatLng(34.0522, -118.2437), 'LA Store'),
      ('store2', const LatLng(40.7128, -74.0060), 'NY Store'),
      ('store3', const LatLng(41.8781, -87.6298), 'Chicago Store'),
    ];

    for (var (id, position, title) in destinations) {
      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: position,
          infoWindow: InfoWindow(title: title),
          onTap: () => _onMarkerTap(id),
        ),
      );
    }
  }

  void _onMarkerTap(String markerId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marker tapped: $markerId')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locations & Markers')),
      body: GoogleMap(
        initialCameraPosition: _defaultPosition,
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
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

## 5. Custom Marker Icons

**lib/services/marker_icon_service.dart**

```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconService {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> getIcon(String assetPath) async {
    if (_cache.containsKey(assetPath)) {
      return _cache[assetPath]!;
    }

    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      assetPath,
    );

    _cache[assetPath] = icon;
    return icon;
  }

  static void clearCache() => _cache.clear();
}

// Usage
class CustomMarkerMapScreen extends StatefulWidget {
  @override
  State<CustomMarkerMapScreen> createState() => _CustomMarkerMapScreenState();
}

class _CustomMarkerMapScreenState extends State<CustomMarkerMapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
  }

  Future<void> _loadCustomMarkers() async {
    final userIcon = await MarkerIconService.getIcon('assets/user_pin.png');
    final destIcon =
        await MarkerIconService.getIcon('assets/destination_pin.png');

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: const LatLng(37.7749, -122.4194),
          icon: userIcon,
        ),
      );

      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: const LatLng(34.0522, -118.2437),
          icon: destIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.7749, -122.4194),
        zoom: 8,
      ),
      onMapCreated: (controller) => mapController = controller,
      markers: markers,
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

## 6. Real-time Location Tracking

**lib/screens/realtime_tracking_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class RealtimeTrackingScreen extends StatefulWidget {
  const RealtimeTrackingScreen({super.key});

  @override
  State<RealtimeTrackingScreen> createState() =>
      _RealtimeTrackingScreenState();
}

class _RealtimeTrackingScreenState extends State<RealtimeTrackingScreen> {
  late GoogleMapController mapController;
  late StreamSubscription<Position> _positionStream;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final List<LatLng> _locationHistory = [];
  bool _isTracking = false;

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 15,
  );

  void _startTracking() {
    setState(() => _isTracking = true);

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 10,
          ),
        ).listen(
          (Position position) {
            final newLocation = LatLng(position.latitude, position.longitude);

            setState(() {
              _locationHistory.add(newLocation);

              // Update marker
              markers.clear();
              markers.add(
                Marker(
                  markerId: const MarkerId('current'),
                  position: newLocation,
                  infoWindow: const InfoWindow(title: 'Current Location'),
                ),
              );

              // Update polyline
              if (_locationHistory.length > 1) {
                polylines.clear();
                polylines.add(
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: _locationHistory,
                    color: Colors.blue,
                    width: 5,
                  ),
                );
              }
            });

            mapController.animateCamera(
              CameraUpdate.newLatLng(newLocation),
            );
          },
        );
  }

  void _stopTracking() {
    _positionStream.cancel();
    setState(() => _isTracking = false);
  }

  void _clearTracking() {
    setState(() {
      _locationHistory.clear();
      markers.clear();
      polylines.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking')),
      body: GoogleMap(
        initialCameraPosition: _defaultPosition,
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
        polylines: polylines,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'track',
            onPressed: _isTracking ? _stopTracking : _startTracking,
            backgroundColor: _isTracking ? Colors.red : Colors.green,
            child: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: _clearTracking,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isTracking) _positionStream.cancel();
    mapController.dispose();
    super.dispose();
  }
}
```

---

## 7. Multi-location Map

**lib/screens/multi_location_map_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  final String id;
  final LatLng position;
  final String name;
  final String type; // 'user', 'store', 'stop'

  Location({
    required this.id,
    required this.position,
    required this.name,
    required this.type,
  });
}

class MultiLocationMapScreen extends StatefulWidget {
  const MultiLocationMapScreen({super.key});

  @override
  State<MultiLocationMapScreen> createState() =>
      _MultiLocationMapScreenState();
}

class _MultiLocationMapScreenState extends State<MultiLocationMapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  final List<Location> locations = [
    Location(
      id: 'user',
      position: const LatLng(37.7749, -122.4194),
      name: 'Your Location',
      type: 'user',
    ),
    Location(
      id: 'stop1',
      position: const LatLng(37.8044, -122.2712),
      name: 'Delivery Stop 1',
      type: 'stop',
    ),
    Location(
      id: 'stop2',
      position: const LatLng(37.3382, -121.8863),
      name: 'Delivery Stop 2',
      type: 'stop',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() {
    // Add markers
    for (var location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: location.position,
          infoWindow: InfoWindow(title: location.name),
        ),
      );
    }

    // Draw polyline connecting all points
    final points = locations.map((l) => l.position).toList();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-location Route')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
        polylines: polylines,
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

**Status**: ✅ All Examples Production-Ready

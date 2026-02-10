# Google Maps - Production Code Examples

**Copy-paste ready code for Google Maps integration, location services, and advanced features**

---

## 📋 Code Examples Index

1. [Location Service](#1-location-service)
2. [Map Screen with Basic Map](#2-map-screen-basic)
3. [Map with Markers](#3-map-with-markers)
4. [Map with Polylines](#4-map-with-polylines)
5. [Map with Polygons](#5-map-with-polygons)
6. [Location Tracking](#6-location-tracking)
7. [Geocoding Service](#7-geocoding-service)

---

## 1. Location Service

**lib/services/location_service.dart**

```dart
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  /// Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Request location permission from user
  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Get current location as Position
  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await hasLocationPermission();
      
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Stream of location updates
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
        timeLimit: Duration(seconds: 5),
      ),
    );
  }

  /// Calculate distance between two coordinates (in meters)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Check if location is enabled on device
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open app settings to enable location
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
```

---

## 2. Map Screen - Basic

**lib/screens/map_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

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
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final hasPermission = await LocationService.hasLocationPermission();
    
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission required')),
        );
      }
      return;
    }

    final currentLocation = await LocationService.getCurrentLocation();
    if (currentLocation != null && mounted) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation.latitude,
              currentLocation.longitude,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    // Handle camera movement
    print('Camera moved to: ${position.target}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
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

## 3. Map with Markers

**lib/screens/map_with_markers_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String id;
  final LatLng position;
  final String title;
  final String? snippet;

  MarkerModel({
    required this.id,
    required this.position,
    required this.title,
    this.snippet,
  });
}

class MapWithMarkersScreen extends StatefulWidget {
  const MapWithMarkersScreen({super.key});

  @override
  State<MapWithMarkersScreen> createState() => _MapWithMarkersScreenState();
}

class _MapWithMarkersScreenState extends State<MapWithMarkersScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  final List<MarkerModel> _markerData = [
    MarkerModel(
      id: 'sf',
      position: const LatLng(37.7749, -122.4194),
      title: 'San Francisco',
      snippet: 'Golden Gate City',
    ),
    MarkerModel(
      id: 'la',
      position: const LatLng(34.0522, -118.2437),
      title: 'Los Angeles',
      snippet: 'City of Angels',
    ),
    MarkerModel(
      id: 'ny',
      position: const LatLng(40.7128, -74.0060),
      title: 'New York',
      snippet: 'Big Apple',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    for (var markerData in _markerData) {
      final marker = Marker(
        markerId: MarkerId(markerData.id),
        position: markerData.position,
        infoWindow: InfoWindow(
          title: markerData.title,
          snippet: markerData.snippet,
          onTap: () => _onMarkerTapped(markerData.id),
        ),
        onTap: () => _onMarkerTapped(markerData.id),
      );
      markers.add(marker);
    }
    setState(() {});
  }

  void _onMarkerTapped(String markerId) {
    print('Marker tapped: $markerId');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marker $markerId tapped')),
    );
  }

  void _addNewMarker(LatLng position, String title) {
    final newMarker = Marker(
      markerId: MarkerId(DateTime.now().toString()),
      position: position,
      infoWindow: InfoWindow(title: title),
    );
    setState(() {
      markers.add(newMarker);
    });
  }

  void _clearMarkers() {
    setState(() {
      markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Markers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearMarkers,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
        onLongPress: (LatLng position) {
          _addNewMarker(position, 'New Location');
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

---

## 4. Map with Polylines

**lib/screens/map_with_polylines_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithPolylinesScreen extends StatefulWidget {
  const MapWithPolylinesScreen({super.key});

  @override
  State<MapWithPolylinesScreen> createState() => _MapWithPolylinesScreenState();
}

class _MapWithPolylinesScreenState extends State<MapWithPolylinesScreen> {
  late GoogleMapController mapController;
  final Set<Polyline> polylines = {};
  final List<LatLng> routePoints = [];

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeRoute();
  }

  void _initializeRoute() {
    final route = [
      const LatLng(37.7749, -122.4194), // San Francisco
      const LatLng(37.8044, -122.2712), // Oakland
      const LatLng(37.3382, -121.8863), // San Jose
    ];

    setState(() {
      routePoints.addAll(route);
    });

    _addPolyline('route1', route, Colors.blue, 5);
  }

  void _addPolyline(
    String id,
    List<LatLng> points,
    Color color,
    int width,
  ) {
    final polyline = Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: color,
      width: width,
      patterns: const [
        PatternItem.dash(20),
        PatternItem.gap(10),
      ],
      geodesic: true,
      onTap: () {
        print('Polyline $id tapped');
      },
    );

    setState(() {
      polylines.add(polyline);
    });
  }

  void _addNewPolylinePoint(LatLng point) {
    setState(() {
      routePoints.add(point);
    });

    if (routePoints.length > 1) {
      _addPolyline(
        'route_${routePoints.length}',
        routePoints.toList(),
        Colors.red,
        3,
      );
    }
  }

  void _clearRoute() {
    setState(() {
      polylines.clear();
      routePoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Polylines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearRoute,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => mapController = controller,
        polylines: polylines,
        onLongPress: (LatLng position) {
          _addNewPolylinePoint(position);
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

---

## 5. Map with Polygons

**lib/screens/map_with_polygons_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithPolygonsScreen extends StatefulWidget {
  const MapWithPolygonsScreen({super.key});

  @override
  State<MapWithPolygonsScreen> createState() => _MapWithPolygonsScreenState();
}

class _MapWithPolygonsScreenState extends State<MapWithPolygonsScreen> {
  late GoogleMapController mapController;
  final Set<Polygon> polygons = {};
  final Set<Circle> circles = {};

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeGeometries();
  }

  void _initializeGeometries() {
    // Add delivery zone polygon
    _addPolygon('zone1', [
      const LatLng(37.7700, -122.4100),
      const LatLng(37.7800, -122.4100),
      const LatLng(37.7800, -122.4300),
      const LatLng(37.7700, -122.4300),
    ], Colors.blue, Colors.blueAccent);

    // Add service radius circle
    _addCircle('radius1', const LatLng(37.7749, -122.4194), 1000, Colors.red);
  }

  void _addPolygon(
    String id,
    List<LatLng> points,
    Color fillColor,
    Color strokeColor,
  ) {
    final polygon = Polygon(
      polygonId: PolygonId(id),
      points: points,
      fillColor: fillColor.withOpacity(0.3),
      strokeColor: strokeColor,
      strokeWidth: 2,
      onTap: () {
        print('Polygon $id tapped');
      },
    );

    setState(() {
      polygons.add(polygon);
    });
  }

  void _addCircle(String id, LatLng center, double radius, Color color) {
    final circle = Circle(
      circleId: CircleId(id),
      center: center,
      radius: radius,
      fillColor: color.withOpacity(0.2),
      strokeColor: color,
      strokeWidth: 2,
      onTap: () {
        print('Circle $id tapped');
      },
    );

    setState(() {
      circles.add(circle);
    });
  }

  void _clearGeometries() {
    setState(() {
      polygons.clear();
      circles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Polygons & Circles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearGeometries,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => mapController = controller,
        polygons: polygons,
        circles: circles,
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

## 6. Location Tracking

**lib/screens/location_tracking_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import 'dart:async';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key});

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  late GoogleMapController mapController;
  late StreamSubscription<dynamic> _locationSubscription;
  
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final List<LatLng> _locationHistory = [];
  
  bool _isTracking = false;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    final hasPermission = await LocationService.hasLocationPermission();
    if (!hasPermission) {
      await LocationService.requestLocationPermission();
    }
  }

  void _startTracking() {
    if (_isTracking) return;

    setState(() {
      _isTracking = true;
      _locationHistory.clear();
      markers.clear();
      polylines.clear();
    });

    _locationSubscription = LocationService.getLocationStream().listen(
      (position) {
        final newLocation = LatLng(position.latitude, position.longitude);

        setState(() {
          _locationHistory.add(newLocation);

          // Update current position marker
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId('current'),
              position: newLocation,
              infoWindow: InfoWindow(
                title: 'Current Location',
                snippet: '${position.latitude}, ${position.longitude}',
              ),
            ),
          );

          // Update polyline with history
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

        // Auto-center map on current location
        mapController.animateCamera(
          CameraUpdate.newLatLng(newLocation),
        );
      },
      onError: (error) {
        print('Location error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: $error')),
        );
      },
    );
  }

  void _stopTracking() {
    _locationSubscription.cancel();
    setState(() {
      _isTracking = false;
    });
  }

  void _clearHistory() {
    setState(() {
      _locationHistory.clear();
      markers.clear();
      polylines.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'start_stop',
            onPressed: _isTracking ? _stopTracking : _startTracking,
            backgroundColor: _isTracking ? Colors.red : Colors.green,
            child: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: _clearHistory,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.delete),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'info',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tracking: $_isTracking | Points: ${_locationHistory.length}',
                  ),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isTracking) {
      _locationSubscription.cancel();
    }
    mapController.dispose();
    super.dispose();
  }
}
```

---

## 7. Geocoding Service

**lib/services/geocoding_service.dart**

```dart
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodeService {
  /// Convert address string to LatLng coordinates
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
    return null;
  }

  /// Convert LatLng coordinates to human-readable address
  static Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
      }
    } catch (e) {
      print('Reverse geocoding error: $e');
    }
    return null;
  }

  /// Get address components from coordinates
  static Future<AddressComponents?> getAddressComponents(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return AddressComponents(
          street: place.street ?? '',
          city: place.locality ?? '',
          state: place.administrativeArea ?? '',
          postalCode: place.postalCode ?? '',
          country: place.country ?? '',
        );
      }
    } catch (e) {
      print('Error getting address components: $e');
    }
    return null;
  }
}

class AddressComponents {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressComponents({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  String toFullAddress() {
    return '$street, $city, $state $postalCode, $country';
  }

  @override
  String toString() => toFullAddress();
}
```

**Usage Example**:

```dart
// Convert address to coordinates
final coordinates = await GeocodeService.getCoordinatesFromAddress('1600 Pennsylvania Avenue NW, Washington, DC');
print('Coordinates: ${coordinates?.latitude}, ${coordinates?.longitude}');

// Convert coordinates to address
final address = await GeocodeService.getAddressFromCoordinates(37.7749, -122.4194);
print('Address: $address');

// Get address components
final components = await GeocodeService.getAddressComponents(37.7749, -122.4194);
print('City: ${components?.city}');
print('State: ${components?.state}');
```

---

## 📌 How to Use These Examples

1. **Copy the entire file** into your project
2. **Update imports** as needed
3. **Replace placeholder values** (API keys, coordinates, etc.)
4. **Test on a device** for location accuracy
5. **Check logcat/Xcode** for errors

---

## ✅ Testing Each Example

| Example | Test Method |
|---------|------------|
| LocationService | Call getCurrentLocation() |
| MapScreen | Run app and see map |
| Markers | Long-press to add markers |
| Polylines | Long-press to draw route |
| Polygons | View predefined zones |
| Tracking | Tap start button |
| Geocoding | Search address or coordinates |

---

**Status**: ✅ All Examples Production-Ready

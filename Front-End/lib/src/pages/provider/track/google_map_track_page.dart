import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapsTrackPage extends StatefulWidget {
  final LatLng seekerLocation;

  const GoogleMapsTrackPage({required this.seekerLocation, super.key});

  @override
  State<GoogleMapsTrackPage> createState() => _GoogleMapsTrackPageState();
}

class _GoogleMapsTrackPageState extends State<GoogleMapsTrackPage> {
  final loc.Location locationController = loc.Location();
  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('seeker'),
        position: widget.seekerLocation,
        infoWindow: InfoWindow(title: 'Seeker Location'),
      ),
    );
  }

  Future<void> _fetchLocationUpdates() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    final currentLocation = await locationController.getLocation();
    setState(() {
      currentPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      markers.add(
        Marker(
          markerId: MarkerId('provider'),
          position: currentPosition!,
          infoWindow: InfoWindow(title: 'Provider Location'),
        ),
      );
      _updateRoute();
    });

    locationController.onLocationChanged
        .listen((loc.LocationData currentLocation) {
      setState(() {
        currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        markers.removeWhere((m) => m.markerId.value == 'provider');
        markers.add(
          Marker(
            markerId: MarkerId('provider'),
            position: currentPosition!,
            infoWindow: InfoWindow(title: 'Provider Location'),
          ),
        );
        _updateRoute();
      });
    });
  }

  Future<void> _updateRoute() async {
    if (currentPosition == null) return;

    List<LatLng> route =
        await _getRouteBetweenPoints(currentPosition!, widget.seekerLocation);

    setState(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: route,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  Future<List<LatLng>> _getRouteBetweenPoints(LatLng start, LatLng end) async {
    final String apiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> points = [];
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final polyline = route['overview_polyline']['points'];
        points.addAll(_decodePolyline(polyline));
      }
      return points;
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Provider'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.seekerLocation,
              zoom: 14.0,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _fetchLocationUpdates,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

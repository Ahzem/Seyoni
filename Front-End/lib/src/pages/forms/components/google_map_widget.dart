import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng) onLocationPicked;

  const GoogleMapWidget({
    super.key,
    this.initialLocation,
    required this.onLocationPicked,
  });

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  LatLng? _pickedLocation;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // Handle permission denied
        return;
      }
    }

    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _pickedLocation = widget.initialLocation ??
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  void _pickLocation(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  void _confirmLocation() {
    if (_pickedLocation != null) {
      widget.onLocationPicked(_pickedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 24, color: kPrimaryColor),
                SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      barrierColor: Colors.black.withOpacity(0.8),
                      backgroundColor: kPrimaryColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => SizedBox(
                        height: MediaQuery.of(ctx).size.height * 0.8,
                        child: Column(
                          children: [
                            Expanded(
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _pickedLocation ??
                                      LatLng(6.927079, 79.861244),
                                  zoom: 14,
                                ),
                                onTap: _pickLocation,
                                markers: _pickedLocation != null
                                    ? {
                                        Marker(
                                          markerId: MarkerId('picked-location'),
                                          position: _pickedLocation!,
                                        ),
                                      }
                                    : {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: _confirmLocation,
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Pick Location on Map",
                    style: kBodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

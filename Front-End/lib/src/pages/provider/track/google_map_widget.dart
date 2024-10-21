import 'dart:ui';
import '../../../constants/constants_color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import '../../../widgets/custom_button.dart';

class GoogleMapsTrackPage extends StatefulWidget {
  const GoogleMapsTrackPage({super.key});

  @override
  State<GoogleMapsTrackPage> createState() => _GoogleMapsTrackPageState();
}

class _GoogleMapsTrackPageState extends State<GoogleMapsTrackPage> {
  final loc.Location locationController = loc.Location();
  GoogleMapController? mapController;
  LatLng? currentPosition;

  static const LatLng colombo = LatLng(6.925921399443209, 79.85997663648692);

  Future<void> fetchLocationUpdates() async {
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

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude ?? 0.0,
            currentLocation.longitude ?? 0.0,
          );
        });
      }
    });
  }

  void _goToCurrentLocation() async {
    final currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition = LatLng(
          currentLocation.latitude ?? 0.0,
          currentLocation.longitude ?? 0.0,
        );
      });
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPosition!, zoom: 15),
          ),
        );
      }
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      }
    } catch (e) {
      print('Error occurred while getting address from coordinates: $e');
    }
    // Return latitude and longitude as a fallback
    return '${position.latitude},${position.longitude}';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white.withOpacity(0.1),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          const CameraPosition(target: colombo, zoom: 14),
                        ),
                      );
                    },
                    initialCameraPosition:
                        const CameraPosition(target: colombo, zoom: 14),
                    markers: {
                      if (currentPosition != null)
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: currentPosition!,
                          draggable: true,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueYellow),
                          onDragEnd: (newPosition) {
                            setState(() {
                              currentPosition = newPosition;
                            });
                          },
                        ),
                    },
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    onCameraMove: (position) {
                      // Update the marker position when the camera moves
                      setState(() {
                        currentPosition = position.target;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: _goToCurrentLocation,
                      ),
                    ),
                    PrimaryOutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancel',
                    ),
                    PrimaryFilledButton(
                      text: 'Pick',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

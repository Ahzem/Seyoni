import 'dart:async';
import 'dart:ui';
import '../../../../constants/constants_color.dart';
import '../../../../constants/constants_font.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

import '../../../../widgets/custom_button.dart';

class GoogleMapsBottomSheet extends StatefulWidget {
  const GoogleMapsBottomSheet({super.key});

  @override
  State<GoogleMapsBottomSheet> createState() => _GoogleMapsBottomSheetState();
}

class _GoogleMapsBottomSheetState extends State<GoogleMapsBottomSheet> {
  final loc.Location locationController = loc.Location();
  GoogleMapController? mapController;
  LatLng? currentPosition;
  LatLng? markerPosition;
  final TextEditingController _searchController = TextEditingController();

  StreamSubscription<loc.LocationData>? _locationSubscription;

  static const LatLng colombo = LatLng(6.925921399443209, 79.85997663648692);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _searchController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    _locationSubscription = locationController.onLocationChanged.listen(
      (currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null &&
            mounted) {
          setState(() {
            currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
          });
        }
      },
    );
  }

  void _goToCurrentLocation() async {
    final currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        markerPosition = currentPosition;
      });
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition!, zoom: 15),
        ),
      );
    }
  }

  Future<void> _searchLocation(String query) async {
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);
        setState(() {
          currentPosition = newPosition;
          markerPosition = newPosition;
        });
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 15),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error occurred while searching for location: $e');
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
        return '${placemark.street}, ${placemark.locality}, ${placemark.country}'
            .replaceAll('null', '')
            .replaceAll(', null', '');
      }
    } catch (e) {
      debugPrint('Error occurred while getting address from coordinates: $e');
    }
    return '${position.latitude},${position.longitude}';
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: kInputTextStyle,
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search location',
                    labelStyle: kBodyTextStyle,
                    prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  onSubmitted: _searchLocation,
                ),
              ),
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
                      if (markerPosition != null)
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: markerPosition!,
                          draggable: true,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueYellow),
                          onDragEnd: (newPosition) {
                            setState(() {
                              markerPosition = newPosition;
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
                        markerPosition = position.target;
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
                      onPressed: () async {
                        if (markerPosition != null) {
                          final address =
                              await _getAddressFromLatLng(markerPosition!);
                          if (!mounted) return;
                          Navigator.pop(context, {
                            'address': address,
                            'latitude': markerPosition!.latitude,
                            'longitude': markerPosition!.longitude,
                          });
                        }
                      },
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

class CustomLocationField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onTap;

  const CustomLocationField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white.withOpacity(0.1),
            child: TextFormField(
              cursorColor: kPrimaryColor,
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: kBodyTextStyle,
                icon: const Icon(Icons.location_on, color: kPrimaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
              style: kInputTextStyle,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

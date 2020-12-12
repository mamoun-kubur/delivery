import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  MapWidget({this.latitude, this.longitude});

  final double latitude;
  final double longitude;

  Set<Marker> markers = {};

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialLocation = CameraPosition(
        zoom: 5.0,
        target: LatLng(
          this.latitude,
          this.longitude,
        ));

    Marker startMarker = Marker(
      markerId: MarkerId('address'),
      position: LatLng(
        this.latitude,
        this.longitude,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(startMarker);
    return GoogleMap(
      markers: markers != null ? Set<Marker>.from(markers) : null,
      initialCameraPosition: _initialLocation,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      zoomGesturesEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  GoogleMapWidget({Key? key}) : super(key: key);

  final controller = Get.put(MapController());
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
            target:
                LatLng(controller.latitude.value, controller.longitude.value),
            zoom: 15),
        markers: controller.markers,
        polylines: Set<Polyline>.of(controller.polylines.values),
        onMapCreated: (GoogleMapController con) {
          _controller.complete(con);
          controller.newGoogleMapController = con;
          controller.currentLocation();
        },
      ),
    );
  }
}
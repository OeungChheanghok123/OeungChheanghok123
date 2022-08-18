import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  GoogleMapWidget({Key? key}) : super(key: key);

  final mapController = Get.put(MapController());
  final Completer<GoogleMapController> _controller = Completer();
  late final GoogleMapController newGoogleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(mapController.latitude.value, mapController.longitude.value),
          zoom: mapController.zoom.value,
        ),
        markers: Set<Marker>.of(mapController.markers),
        polylines: Set<Polyline>.of(mapController.polyLines.values),
        onMapCreated: (GoogleMapController con) {
          _controller.complete(con);
          newGoogleMapController = con;
        },
      ),),
    );
  }
}
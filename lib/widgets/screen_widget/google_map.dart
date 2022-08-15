import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final controller = Get.put(MapController());
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  String googleApiKey = "AIzaSyBSyQsntLybWDXtK0XIhYOHMNs9z-6LdVg";
  LatLng destinationCustomer = const LatLng(11.569042861795637, 104.90094500407777);

  @override
  void initState() {
    setState((){
      initMarkers().then((value) {
        controller.markers = value;
      });
      getPolyline();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(controller.latitude.value, controller.longitude.value),
          zoom: 15,
        ),
        markers: controller.markers,
        polylines: Set<Polyline>.of(controller.polyLines.values),
        onMapCreated: (GoogleMapController con) {
          _controller.complete(con);
          newGoogleMapController = con;
        },
      ),),
    );
  }
  getPolyline() async {
    Position pos = await controller.getCurrentPosition();
    PolylineResult result = await controller.polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(pos.latitude, pos.longitude),
      PointLatLng(
        destinationCustomer.latitude,
        destinationCustomer.longitude,
      ),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach((PointLatLng point) {
        controller.polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }
  addPolyLine() {
    PolylineId id = const PolylineId('poly123');
    Polyline polyline = Polyline(width: 5,
        polylineId: id, color: Colors.red, points: controller.polylineCoordinates);
    controller.polyLines[id] = polyline;
    setState((){});
  }
  Future<Set<Marker>> initMarkers() async {
    final icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    List<Marker> markers = <Marker>[];
    for (final location in controller.myPosLatLng) {
      debugPrint(
          'latitude: ${location.latitude}, longitude: ${location.longitude}');
      final marker = Marker(
        markerId: MarkerId(location.toString()),
        infoWindow: InfoWindow(
          title: "Some Company",
          snippet: "Some Company branch",
          onTap: () =>
              debugPrint("tapped ${location.latitude}, ${location.longitude}"),
        ),
        position: location,
        icon: icon,
      );
      markers.add(marker);
    }
    return markers.toSet();
  }
}
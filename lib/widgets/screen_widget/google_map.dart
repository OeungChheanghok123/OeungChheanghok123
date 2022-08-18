import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final controller = Get.put(MapController());
  final Completer<GoogleMapController> _controller = Completer();
  late final GoogleMapController newGoogleMapController;
  final googleApiKey = "AIzaSyBSyQsntLybWDXtK0XIhYOHMNs9z-6LdVg";

  @override
  void initState() {
    initMarkers().then((marker) {
      controller.markers = marker;
    });
    getPolyline();
    setState(() {});
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
          zoom: controller.zoom.value,
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

  Future<Set<Marker>> initMarkers() async {
    final icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    List<Marker> markers = <Marker>[];
    for (final location in controller.myPosLatLng) {
      final marker = Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: icon,
        infoWindow: InfoWindow(
          title: "Some Company",
          snippet: "Some Company branch",
          onTap: () => debugPrint("tapped ${location.latitude}, ${location.longitude}"),
        ),
      );
      markers.add(marker);
    }
    return markers.toSet();
  }
  void getPolyline() async {
    Position pos = await controller.getCurrentPosition();
    PolylineResult result = await controller.polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(pos.latitude, pos.longitude),
      PointLatLng(
        controller.destinationMerchant.latitude,
        controller.destinationMerchant.longitude,
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
  void addPolyLine() {
    PolylineId id = const PolylineId('polyline');
    Polyline polyline = Polyline(
      width: 5,
      polylineId: id,
      color: red,
      points: controller.polylineCoordinates,
    );
    controller.polyLines[id] = polyline;
    setState((){});
  }
}
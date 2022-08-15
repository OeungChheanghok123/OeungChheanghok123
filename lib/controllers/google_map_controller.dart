// ignore_for_file: unnecessary_null_comparison
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  double zoom = 16;
  Set<Marker> markers = <Marker>{};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> myPosLatLng = [
    const LatLng(11.56347939900025, 104.9115677945891),
    const LatLng(11.569042861795637, 104.90094500407777),
  ];

  @override
  void onInit() {
    getCurrentCameraPosition();
    super.onInit();
  }

  Future<Position> getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } else {
      final request = await Geolocator.requestPermission();
      if (request == LocationPermission.always ||
          request == LocationPermission.whileInUse) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else {
        throw Exception("Access to Location permission was denied.");
      }
    }
  }
  Future<CameraPosition> getCurrentCameraPosition() async {
    Position _currentPos = await getCurrentPosition();
    latitude.value = _currentPos.latitude;
    longitude.value = _currentPos.longitude;
    if (_currentPos != null) {
      return CameraPosition(
        target: LatLng(latitude.value, longitude.value),
        zoom: zoom,
      );
    } else {
      throw Exception(
          'Error current location because Google Maps permission was denied.');
    }
  }
}

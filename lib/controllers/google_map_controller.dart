// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double zoom = 15;

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
  if (_currentPos != null) {
    return CameraPosition(
      target: LatLng(_currentPos.latitude, _currentPos.longitude),
      zoom: zoom,
    );
  } else {
    throw Exception(
        'Error current location because Google Maps permission was denied.');
  }
}

List<LatLng> myPosLatLng = [
  //const LatLng(11.56347939900025, 104.9115677945891),
  const LatLng(11.569042861795637, 104.90094500407777),
];

class MapController extends GetxController {
  late LocationPermission permission;
  late Position position;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  late LatLng latLngPosition;
  late CameraPosition cameraPosition;
  late GoogleMapController newGoogleMapController;

  void currentLocation() async {
    permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    latLngPosition = LatLng(latitude.value, longitude.value);
    cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    debugPrint('latitude: ${latitude.value} and longitude: ${longitude.value}');
  }

  // from here is code from teacher kosal
  @override
  void onInit() {
    initMarkers().then((value) {
      markers = value;
    });
    super.onInit();
  }

  Set<Marker> markers = <Marker>{};
  Future<Set<Marker>> initMarkers() async {
    final icon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    List<Marker> markers = <Marker>[];
    for (final location in myPosLatLng) {
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

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApiKey = "AIzaSyBSyQsntLybWDXtK0XIhYOHMNs9z-6LdVg";

  // ABA Bank Head Office
  LatLng destinationCustomer = const LatLng(11.569042861795637, 104.90094500407777);

  getPolyline() async {
    Position pos = await getCurrentPosition();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
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
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }

  addPolyLine() {
    PolylineId id = const PolylineId('poly123');
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
  }
}

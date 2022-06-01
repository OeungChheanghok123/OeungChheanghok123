import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/order_controller.dart';

class GoogleMapWidget extends StatelessWidget {
  final double paddingBottom;

  const GoogleMapWidget({
    Key? key,
    this.paddingBottom = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    OrderController orderController = Get.put(OrderController());
    final Completer<GoogleMapController> _controller = Completer();

    return GoogleMap(
      padding: EdgeInsets.only(bottom: paddingBottom),
      mapType: MapType.normal,
      initialCameraPosition:  CameraPosition(
        target: LatLng(orderController.latitude, orderController.longitude),
        zoom: 15,
      ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        orderController.newGoogleMapController = controller;
        orderController.currentLocation();
      },
    );
  }
}
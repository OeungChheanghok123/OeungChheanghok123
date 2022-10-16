import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';
import 'package:loy_eat/controllers/order_detail_contrller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class GoogleMapWidget extends StatelessWidget {
  GoogleMapWidget({Key? key}) : super(key: key);

  final mapController = Get.put(MapController());
  final orderDetailController = Get.put(OrderDetailController());
  final Completer<GoogleMapController> _controller = Completer();
  late final GoogleMapController newGoogleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(text: 'Order No: ${orderDetailController.getOrderNo.value}', isTitle: true),
        backgroundColor: white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            orderDetailController.onInit();
            Get.back();
          },
            child: const IconWidget(icon: Icons.arrow_back_ios_outlined, size: 32, color: black)),
      ),
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
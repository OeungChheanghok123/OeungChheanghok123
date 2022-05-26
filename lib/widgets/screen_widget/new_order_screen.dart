import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/svg_picture_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {

  OrderController orderController = Get.put(OrderController());
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: lightGray,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _buildGoogleMap,
            _buildCard,
          ],
        ),
      ),
    );
  }

  Widget get _buildGoogleMap {
    return GoogleMap(
      padding: const EdgeInsets.only(bottom: 0),
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
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
  Widget get _buildCard {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo(),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildText(
                              text: 'From',
                              size: 14,
                              color: silver,
                            ),
                            _buildText(
                              text: 'Cafe Amazon (PPIU)',
                              size: 12,
                              color: black,
                            ),
                            _buildText(
                              text: '#36, St.169, Sangkat Veal Vong, Khan 7 Makara',
                              size: 11,
                              color: black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Space(
                    height: 30,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogo(),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText(
                                text: 'To',
                                size: 14,
                                color: silver,
                              ),
                              _buildText(
                                text: 'Moun Sovongdy',
                                size: 12,
                                color: black,
                              ),
                              _buildText(
                                text: '#23, St.344, Sangkat Dangkor, Khan Dangkor Khan Dangkor',
                                size: 11,
                                color: black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: silver,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ButtonWidget(
                          onPressed: () {},
                          width: 130,
                          color: white,
                          borderSide: BorderSide(color: text.withOpacity(0.8)),
                          child: const TextWidget(
                            text: 'Reject',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ButtonWidget(
                          onPressed: () {},
                          width: 130,
                          child: const TextWidget(
                            text: 'Accept',
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: carrot,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: TextWidget(
                    text: '1s',
                    size: 9,
                    color: white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: rabbit,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const SvgPictureWidget(
        imageString: 'assets/image/loy_eat_logo.svg',
        label: 'logo',
      ),
    );
  }
  Widget _buildText({required String text, required Color color, required double size}) {
    return TextWidget(
      text: text,
      size: size,
      color: color,
      //textOverflow: TextOverflow.ellipsis,
    );
  }
}
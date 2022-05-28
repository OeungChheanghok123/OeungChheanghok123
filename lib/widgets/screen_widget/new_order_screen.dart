import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
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
  Widget get _buildCard {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 260,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailProfile(
                    imageString: 'assets/image/loy_eat_logo.svg',
                    labelString: 'merchant logo',
                    status: 'From',
                    titleString: 'Cafe Amazon (PPIU)',
                    detailString: '#36, St. 169, Sangkat Veal Vong, Khan 7 Makara',
                  ),
                  _buildSpace(height: 25),
                  _buildDetailProfile(
                    imageString: 'assets/image/loy_eat_logo.svg',
                    labelString: 'user logo',
                    status: 'To',
                    titleString: 'Moun Sovongdy',
                    detailString: '#23, St. 344, Sangkat Dangkor, Khan Dangkor',
                  ),
                  _buildLine(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconAndText(
                        icon: Icons.access_time,
                        title: '20 min',
                      ),
                      _buildIconAndText(
                        icon: Icons.directions_bike,
                        title: '1.2 km',
                      ),
                      _buildIconAndText(
                        icon: Icons.monetization_on,
                        title: '\$19.00',
                        color: rabbit,
                      ),
                      _buildIconAndText(
                        icon: Icons.directions_bike,
                        title: 'Tip = \$1.00',
                        showLine: false,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton('Reject', red),
                        _buildButton('Accept', succeed),
                      ],
                    ),
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
                child: Center(
                  child: Obx(() => TextWidget(
                    text: '${orderController.startCounter.value}',
                    size: 9,
                    color: white,
                    textAlign: TextAlign.center,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailProfile({required String imageString, required String labelString, required String status, required String titleString, required String detailString}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: rabbit,
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPictureWidget(
            imageString: imageString,
            label: labelString,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(
                  text: status,
                  size: 14,
                  color: silver,
                ),
                _buildText(
                  text: titleString,
                  size: 12,
                  color: black,
                ),
                _buildText(
                  text: detailString,
                  size: 11,
                  color: black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLine() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: silver,
      margin: const EdgeInsets.only(top: 10),
    );
  }
  Widget _buildText({required String text, required Color color, required double size}) {
    return TextWidget(
      text: text,
      size: size,
      color: color,
      textOverflow: TextOverflow.ellipsis,
    );
  }
  Widget _buildSpace({required double height}) {
    return Space(height: height);
  }
  Widget _buildIconAndText({required IconData icon, required String title, Color color = black, bool showLine = true}){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          showLine ? IconWidget(
            icon: icon,
            size: 20,
            color: color,
          ) : const SizedBox.shrink(),
          showLine ? _buildSpace(height: 5) : const SizedBox.shrink(),
          TextWidget(
            text: title,
            color: color,
            size: 11,
          ),
          showLine ? Container(
            width: 1,
            height: 15,
            color: black,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
  Widget _buildButton(String buttonText, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ButtonWidget(
        onPressed: () {},
        width: 130,
        color: color,
        borderSide: BorderSide.none,
        child: TextWidget(
          text: buttonText,
          fontWeight: FontWeight.w500,
          color: white,
        ),
      ),
    );
  }
}
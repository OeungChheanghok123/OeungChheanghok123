import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_accept_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/screen_widget/google_map.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class OrderAccept extends StatelessWidget {
  OrderAccept({Key? key}) : super(key: key);

  final orderAcceptController = Get.put(OrderAcceptController());
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    var index = 0.obs;

    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            FutureBuilder(
              future: wait3SecAndLoadData(),
              builder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 65),
                child: GoogleMapWidget(),
              );
            }),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: ConfirmationSlider(
                    height: 50,
                    backgroundColor: rabbit,
                    backgroundShape: BorderRadius.circular(5.0),
                    foregroundColor: white.withOpacity(0.5),
                    foregroundShape: BorderRadius.circular(5.0),
                    text: orderAcceptController.orderStep[index.value],
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                    onConfirmation: () {
                      index.value = index.value + 1;
                      if (index.value == 4) {
                        index.value--;
                        orderController.showDialogRateToCustomer();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Future<Widget> wait3SecAndLoadData() async {
    await Future.delayed(const Duration(seconds: 10));
    return Container();
  }
}

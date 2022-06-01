import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_accept_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/screen_widget/google_map.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class OrderAccept extends StatelessWidget {
  const OrderAccept({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    OrderAcceptController orderAcceptController = Get.put(OrderAcceptController());
    OrderController orderController = Get.put(OrderController());

    var index = 0.obs;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const GoogleMapWidget(paddingBottom: 65),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                  onConfirmation: (){
                    index.value++;
                    if(index.value == 4){
                      index.value--;
                      orderController.showDialogRateToCustomer();
                    }
                  },
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
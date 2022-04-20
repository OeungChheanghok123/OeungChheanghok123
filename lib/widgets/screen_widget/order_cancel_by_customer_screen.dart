import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class OrderCancelByCustomerScreen extends StatelessWidget {
  const OrderCancelByCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.put(OrderController());

    return Container(
      color: white,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconWidget(icon: Icons.sentiment_very_dissatisfied, color: carrot, size: 64,),
          Container(
            width: 280,
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextWidget(
              text: orderController.reasonCustomerCancel,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextWidget(
              text: orderController.orderCancelByCustomer,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: silver,
            ),
          ),
        ],
      ),
    );
  }
}
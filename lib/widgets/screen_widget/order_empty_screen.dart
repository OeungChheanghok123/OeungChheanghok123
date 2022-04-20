import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class OrderEmptyScreen extends StatefulWidget {
  const OrderEmptyScreen({Key? key}) : super(key: key);

  @override
  State<OrderEmptyScreen> createState() => _OrderEmptyScreenState();
}

class _OrderEmptyScreenState extends State<OrderEmptyScreen> {

  OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconWidget(
            icon: Icons.shopping_basket,
            color: carrot,
            size: 100,
          ),
          Container(
            width: 280,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextWidget(
              text: orderController.orderEmpty,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_app_bar.dart';
import 'package:loy_eat/widgets/screen_widget/order_empty_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: HomeScreenAppBar(),
        body: OrderEmptyScreen(),
      ),
    );
  }
}
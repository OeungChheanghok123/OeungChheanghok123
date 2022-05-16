import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_app_bar.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';

class HomeScreen extends StatefulWidget{
   const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        appBar: const HomeScreenAppBar(),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0),
          child: FutureBuilder(
            future: homeController.wait3SecAndLoadData(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                final error = snapshot.error;
                return TextWidget(text: "$error");
              } else if (snapshot.hasData){
                return Container(
                  width: size.width,
                  alignment: Alignment.topCenter,
                  //margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    children: [
                      _buildDatePicker,
                      _buildChart,
                      _buildStatus,
                      _buildBreakDown,
                    ],
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height - 55,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: rabbit),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget get _buildDatePicker {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          TextWidget(text: '15 - Nov - 2021'),
          Space(width: 5),
          IconWidget(icon: Icons.arrow_right_alt, color: black),
          Space(width: 5),
          TextWidget(text: '21 - Nov - 2021'),
          Space(width: 5),
          IconWidget(icon: Icons.arrow_drop_down, color: black),
        ],
      ),
    );
  }
  Widget get _buildChart {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      color: lightGray,
      height: 180,
      child: Card(
        elevation: 1,
        color: white,
        borderOnForeground: false,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: white.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
          child: HomeScreenBarChart(data: homeController.data),
        ),
      ),
    );
  }
  Widget get _buildStatus {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(isTitle: true, text: 'States'.tr),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildCard(
                        title: 'Online',
                        subTitle: homeController.homeModel.value.online,
                      ),
                    ),
                    const Space(),
                    Obx(
                          () => _buildCard(
                        title: 'Distance',
                        subTitle: homeController.homeModel.value.distance,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildCard(
                        title: 'Trips',
                        subTitle: homeController.homeModel.value.trips.toStringAsFixed(0),
                      ),
                    ),
                    const Space(),
                    Obx(
                      () => _buildCard(
                        title: 'Customer',
                        subTitle: homeController.homeModel.value.customerRating,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildCard(
                        title: 'Points',
                        subTitle: homeController.homeModel.value.points.toStringAsFixed(0),
                      ),
                    ),
                    const Space(),
                    Obx(
                      () => _buildCard(
                        title: 'Merchant',
                        subTitle: homeController.homeModel.value.merchantRating,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget get _buildBreakDown {
    const space = Space(height: 8);
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(isTitle: true, text: 'Breakdown'.tr),
          Card(
            elevation: 1,
            borderOnForeground: false,
            margin: const EdgeInsets.only(top: 5),
            color: white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: white.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(text: 'Net delivery fee'),
                      Obx(() => TextWidget(text: '\$${homeController.homeModel.value.deliveryFee.toStringAsFixed(2)}')),
                    ],
                  ),
                  space,
                  DottedLine(
                    dashLength: 1.5,
                    lineThickness: 2,
                    dashColor: silver.withOpacity(0.5),
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(text: 'Bonus'),
                      Obx(() => TextWidget(text: '\$${homeController.homeModel.value.bonus.toStringAsFixed(2)}')),
                    ],
                  ),
                  space,
                  DottedLine(
                    dashLength: 1.5,
                    lineThickness: 2,
                    dashColor: silver.withOpacity(0.5),
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(text: 'Tip'),
                      Obx(() => TextWidget(text: '\$${homeController.homeModel.value.tip.toStringAsFixed(2)}')),
                    ],
                  ),
                  space,
                  Container(
                    height: 1,
                    color: silver.withOpacity(0.5),
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(text: 'Total Earnings'),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: rabbit.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextWidget(
                          text: '\$${homeController.totalEarnings.value.toStringAsFixed(2)}',
                          fontWeight: FontWeight.bold,
                          color: black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required String subTitle}) {
    return Card(
      color: white,
      elevation: 1,
      borderOnForeground: false,
      margin: const EdgeInsets.only(bottom: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: white.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 95,
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget(text: title),
            const Space(),
            Container(
              padding: const EdgeInsets.only(left: 1.5),
              child: _buildDetailText(subTitle),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailText(String text) {
    return TextWidget(text: text, fontWeight: FontWeight.bold);
  }
}
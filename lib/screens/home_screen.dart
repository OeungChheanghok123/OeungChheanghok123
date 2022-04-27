import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_app_bar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
        backgroundColor: white,
        appBar: const HomeScreenAppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: size.width,
            margin: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                _buildDatePicker,
                _buildChart,
                _buildStatus,
                _buildBreakDown,
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<ReportChart> data = [
    ReportChart(date: '15\nMon', price: 12.45, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '16\nTue', price: 30.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '17\nWed', price: 15.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '18\nThu', price: 30.05, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '19\nFri', price: 40.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '20\nSat', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '21\nSun', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
  ];

  Widget get _buildDatePicker {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget> [
              TextWidget(text: '15 - Nov - 2021'),
              Space(width: 5),
              IconWidget(icon: Icons.arrow_right_alt, color: black),
              Space(width: 5),
              TextWidget(text: '21 - Nov - 2021'),
              Space(width: 5),
              IconWidget(icon: Icons.arrow_drop_down, color: black),
            ],
          ),
        ),
      ],
    );
  }
  Widget get _buildChart {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      color: white,
      height: 180,
      child:  HomeScreenBarChart(data: data),
    );
  }
  Widget get _buildStatus {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(isTitle: true, text: 'Stats'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Online'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.online)),
                        ),
                      ],
                    ),
                    const Space(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Distance'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.distance)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Trips'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.trips.toString())),
                        ),
                      ],
                    ),
                    const Space(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Customer'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.customerRating)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Points'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.points.toString())),
                        ),
                      ],
                    ),
                    const Space(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(text: 'Merchant'),
                        const Space(),
                        Container(
                          padding: const EdgeInsets.only(left: 1.5),
                          child: Obx(() => _buildDetailText(homeController.homeModel.value.merchantRating)),
                        ),
                      ],
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
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(isTitle: true, text: 'Breakdown'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                const DottedLine(
                  dashLength: 1.5,
                  lineThickness: 2,
                  dashColor: silver,
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
                const DottedLine(
                  dashLength: 1.5,
                  lineThickness: 2,
                  dashColor: silver,
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
                  color: silver,
                ),
                space,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(text: 'Total Earnings'),
                    Container(
                      color: rabbit,
                      child: TextWidget(text: '\$${homeController.totalEarnings.value.toStringAsFixed(2)}', fontWeight: FontWeight.bold, color: white),
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
  Widget _buildDetailText(String text) {
    return TextWidget(text: text, fontWeight: FontWeight.bold);
  }
}
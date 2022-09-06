import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_app_bar.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';
import 'package:loy_eat/widgets/screen_widget/new_order_card.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final dateFormat = DateFormat('dd-MMM-yyyy');
  final homeController = Get.put(HomeController());
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        appBar: HomeScreenAppBar(),
        body: _buildBody,
        bottomSheet: Obx(() =>
        orderController.isNewOrder.value ? NewOrderCard() : const SizedBox(),
        ),
      ),
    );
  }

  Widget get _buildBody {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(0),
      child: FutureBuilder(
        future: homeController.wait3SecAndLoadData(),
        builder: _buildFunctionBody,
      ),
    );
  }

  Widget _buildFunctionBody(BuildContext context, AsyncSnapshot<Widget> snapshot) {
    if (snapshot.hasError) {
      return TextWidget(text: "${snapshot.error}");
    } else if (snapshot.hasData) {
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
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
  }

  Widget get _buildDatePicker {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      child: InkWell(
        onTap: () => showCalendar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextDateAndIcon(
              text: homeController.startDate.value.tr,
              iconData: Icons.arrow_right_alt,
            ),
            _buildTextDateAndIcon(
              text: homeController.endDate.value.tr,
              iconData: Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextDateAndIcon(
      {required String text, required IconData iconData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(text: text),
        const Space(),
        IconWidget(icon: iconData, color: black),
        const Space(),
      ],
    );
  }

  void showCalendar(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((DateTimeRange? value) {
      if (value != null) {
        DateTimeRange _fromRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _fromRange = value;
        homeController.startDate.value = dateFormat.format(_fromRange.start);
        homeController.endDate.value = dateFormat.format(_fromRange.end);
      }
    });
  }

  Widget get _buildChart {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      color: lightGray,
      height: 180,
      child: Card(
        elevation: 0,
        color: white,
        borderOnForeground: false,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: white.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
          child: HomeScreenBarChart(data: homeController.chartData),
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
          _buildStateWidget,
        ],
      ),
    );
  }

  Widget get _buildStateWidget {
    return Obx(() {
      final status = homeController.data.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = homeController.data.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report.length,
          itemBuilder: stateItemWidget,
        );
      }
    });
  }

  Widget stateItemWidget(BuildContext context, int index) {
    final report = homeController.data.data![index];
    return _buildStatusItem(report);
  }
  Widget _buildStatusItem(DriverReportModel model) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCardState(
                width: 100,
                iconData: Icons.access_time,
                title: 'Online'.tr,
                subTitle: '${model.onlineHour}h:${model.onlineMinute}m',
              ),
              const Space(),
              _buildCardState(
                width: 100,
                iconData: Icons.directions_run,
                title: 'Distance'.tr,
                subTitle: '${model.distance} km',
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCardState(
                width: 100,
                iconData: Icons.local_activity,
                title: 'Point'.tr,
                subTitle: model.point,
              ),
              const Space(),
              _buildCardState(
                width: 100,
                iconData: Icons.motorcycle_rounded,
                title: 'Trip'.tr,
                subTitle: model.trip,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCardState(
                width: 110,
                iconData: Icons.thumbs_up_down,
                title: 'Customer'.tr,
                subTitle: '${model.customerRating} / 5',
              ),
              const Space(),
              _buildCardState(
                width: 110,
                iconData: Icons.thumbs_up_down,
                title: 'Merchant'.tr,
                subTitle: '${model.merchantRating} / 5',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardState(
      {required double width,
        required IconData iconData,
        required String title,
        required String subTitle}) {
    return Card(
      color: white,
      elevation: 0,
      borderOnForeground: false,
      margin: const EdgeInsets.only(bottom: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: white.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconWidget(icon: iconData, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: title, size: 10),
                const Space(),
                TextWidget(
                  text: subTitle,
                  fontWeight: FontWeight.bold,
                  color: rabbit,
                  size: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildBreakDown {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(isTitle: true, text: 'Breakdown'.tr),
          Card(
            color: white,
            elevation: 0,
            borderOnForeground: false,
            margin: const EdgeInsets.only(top: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: white.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: _buildBreakDownWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildBreakDownWidget {
    return Obx(() {
      final status = homeController.data.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = homeController.data.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report.length,
          itemBuilder: breakDownItemWidget,
        );
      }
    });
  }

  Widget breakDownItemWidget(BuildContext context, int index) {
    final report = homeController.data.data![index];
    return _buildBreakDownItem(report);
  }

  Widget _buildBreakDownItem(DriverReportModel model) {
    final totalEarning = double.parse(model.deliveryFee) +
        double.parse(model.bonus) +
        double.parse(model.tip);
    return Column(
      children: [
        _buildCardBreakDown(
          text: 'Net delivery fee'.tr,
          value: '\$${model.deliveryFee}',
        ),
        _buildCardBreakDown(
          text: 'Bonus'.tr,
          value: '\$${model.bonus}',
        ),
        _buildCardBreakDown(
          text: 'Tip'.tr,
          value: '\$${model.tip}',
          isDotted: false,
        ),
        _buildCardBreakDown(
          text: 'Total Earning'.tr,
          value: '\$$totalEarning',
          isNon: true,
        ),
      ],
    );
  }

  Widget _buildCardBreakDown(
      {required String text,
        required String value,
        bool isDotted = true,
        bool isNon = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: text),
            TextWidget(text: value),
          ],
        ),
        isNon ? const SizedBox() : dottedLineWidget(isDotted),
      ],
    );
  }

  Widget dottedLineWidget(bool isDot) {
    return isDot == true
        ? Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: DottedLine(
        dashLength: 1.5,
        lineThickness: 2,
        dashColor: silver.withOpacity(0.5),
      ),
    )
        : Container(
      height: 1,
      color: silver.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/report_controller.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        body: CustomScrollView(
          slivers: [
            _buildSilverAppBar(context),
            _buildSilverBody,
          ],
        ),
      ),
    );
  }

  Widget _buildSilverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 1,
      backgroundColor: lightGray,
      expandedHeight: 650,
      excludeHeaderSemantics: true,
      automaticallyImplyLeading: false,
      flexibleSpace: _buildFlexibleSpaceWidget,
      bottom: _buildPreferredSizeWidget(context),
    );
  }

  Widget get _buildFlexibleSpaceWidget {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateMonthReport,
            _buildChart,
            _buildTotalEarning,
            _buildStatus,
            _buildBreakDown,
          ],
        ),
      ),
    );
  }

  Widget get _buildDateMonthReport {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => TextWidget(
            isTitle: true,
            text: controller.dateMonthReport.value,
          )),
          const IconWidget(
            icon: Icons.arrow_drop_down_sharp,
            size: 20,
            color: black,
          ),
        ],
      ),
    );
  }

  Widget get _buildChart {
    return _buildCard(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: white,
        height: 180,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5),
        child: HomeScreenBarChart(data: controller.chartData),
      ),
    );
  }

  Widget get _buildTotalEarning {
    return Obx(() {
      final status = controller.driverReportData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final reportLength = controller.driverReportData.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reportLength.length,
          itemBuilder: (context, index) {
            final report = controller.driverReportData.data![index];
            return _buildTotalEarningWidget(report);
          },
        );
      }
    });
  }

  Widget _buildTotalEarningWidget(DriverReportModel model) {
    final totalEarning = double.parse(model.deliveryFee) +
        double.parse(model.bonus) +
        double.parse(model.tip);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const IconWidget(
            icon: Icons.monetization_on,
            size: 20,
          ),
          TextWidget(
            text: ' Total Earning: '.tr,
            fontWeight: FontWeight.bold,
          ),
          TextWidget(
            text: '\$${totalEarning.toStringAsFixed(2)}',
            fontWeight: FontWeight.bold,
            color: rabbit,
          ),
        ],
      ),
    );
  }

  Widget get _buildStatus {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(isTitle: true, text: 'States'.tr),
          _buildStatusWidget,
        ],
      ),
    );
  }

  Widget get _buildStatusWidget {
    return Obx(() {
      final status = controller.driverReportData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final reportLength = controller.driverReportData.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reportLength.length,
          itemBuilder: stateItemWidget,
        );
      }
    });
  }

  Widget stateItemWidget(BuildContext context, int index) {
    final report = controller.driverReportData.data![index];
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
                iconData: Icons.access_time,
                title: 'Online'.tr,
                subTitle: '${model.onlineHour}h:${model.onlineMinute}m',
              ),
              const Space(),
              _buildCardState(
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
                iconData: Icons.local_activity,
                title: 'Point'.tr,
                subTitle: model.point,
              ),
              const Space(),
              _buildCardState(
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
      {double width = 100,
        required IconData iconData,
        required String title,
        required String subTitle}) {
    return _buildCard(
      margin: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconWidget(
              icon: iconData,
              size: 24,
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(isTitle: true, text: 'Breakdown'.tr),
        _buildCard(
          margin: const EdgeInsets.only(top: 5),
          child: Container(
            margin: const EdgeInsets.all(10),
            child: _buildBreakDownWidget,
          ),
        ),
      ],
    );
  }

  Widget get _buildBreakDownWidget {
    return Obx(() {
      final status = controller.driverReportData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.driverReportData.data!;
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
    final report = controller.driverReportData.data![index];
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

  PreferredSizeWidget _buildPreferredSizeWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: _buildDetailBar(context),
    );
  }

  Widget _buildDetailBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: TextWidget(
              text: 'Fitter by Date:'.tr,
              fontWeight: FontWeight.w500,
            ),
          ),
          Obx(() => InkWell(
            onTap: () => controller.calenderFunction(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: controller.dataDatePicker.value == ''
                  ? const IconWidget(
                icon: Icons.calendar_today,
                size: 20,
                color: black,
              )
                  : TextWidget(text: controller.dataDatePicker.value),
            ),
          )),
        ],
      ),
    );
  }

  Widget get _buildSilverBody {
    return SliverToBoxAdapter(
      child: _buildOrderBodyWidget,
    );
  }

  Widget get _buildOrderBodyWidget {
    return Obx(() {
      final status = controller.orderData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.orderData.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report.length,
          itemBuilder: orderBodyItem,
        );
      }
    });
  }

  Widget orderBodyItem(BuildContext context, int index) {
    final order = controller.orderData.data![index];
    final deliverOrder = controller.deliverData.data![index];
    return _buildOrderBodyItemWidget(order, deliverOrder);
  }

  Widget _buildOrderBodyItemWidget(
      OrderModel orderModel, DeliverModel deliverModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => TextWidget(
                text: 'Date: ${orderModel.date} ${orderModel.time}',
                fontWeight: FontWeight.bold,
                color: controller.isCanceled.value
                    ? carrot
                    : controller.isDelivered.value
                    ? black
                    : rabbit,
              )),
              const Spacer(),
              TextWidget(
                text: deliverModel.process,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: 1.5,
            color: silver,
          ),
          InkWell(
            onTap: () => controller.cardOrder(orderModel.orderId),
            child: _buildCard(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextWidget(text: 'Order No: #${orderModel.orderId} '),
                        const Spacer(),
                        TextWidget(
                            text: 'Total Earning: '.tr,
                            size: 10,
                            fontWeight: FontWeight.w500),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 3),
                          decoration: BoxDecoration(
                            color: controller.isDelivered.value
                                ? rabbit.withOpacity(0.5)
                                : carrot.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextWidget(
                            text:
                            '\$${double.parse(deliverModel.deliveryFee).toStringAsFixed(2)}',
                            size: 11,
                            fontWeight: FontWeight.w600,
                            color: black.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const Space(),
                    Row(
                      children: [
                        TextWidget(
                          text: '${orderModel.merchantName} ' +
                              'to'.tr +
                              ' ${orderModel.customerName}',
                          size: 10,
                          color: text,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildIconAndText(
                              index: 1,
                              iconData: Icons.directions_bike_outlined,
                              text: deliverModel.distance,
                            ),
                            _buildIconAndText(
                              index: 2,
                              iconData: Icons.watch_later,
                              text: deliverModel.period,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required Widget child,
        EdgeInsetsGeometry margin = const EdgeInsets.all(0)}) {
    return Card(
      color: white,
      elevation: 0,
      borderOnForeground: false,
      margin: margin,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: white.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget _buildIconAndText(
      {required int index, required IconData iconData, required String text}) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconWidget(
            icon: iconData,
            color: silver,
            size: 12,
          ),
          const Space(width: 1),
          index == 1
              ? TextWidget(text: '$text Km', color: silver, size: 9)
              : TextWidget(text: '$text min', color: silver, size: 9),
        ],
      ),
    );
  }
}
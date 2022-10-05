import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_app_bar.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';
import 'package:loy_eat/widgets/screen_widget/new_order_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final dateFormat = DateFormat('dd-MMM-yyyy');
  final homeController = Get.put(HomeController());
  final newOrderController = Get.put(NewOrderCardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        appBar: HomeScreenAppBar(),
        body: _buildBody,
        bottomSheet: Obx(() => newOrderController.newOrderId.value != '' && homeController.isOnline.value == true ? NewOrderCard() : const SizedBox(),
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
      return Obx(() => Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDatePicker,
            _buildChart,
            _buildStatus,
            _buildBreakDown,
          ],
        ),
      ));
    } else {
      return Container(
        height: MediaQuery.of(context).size.height - 55,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: rabbit),
      );
    }
  }

  Widget get _buildDatePicker {
    return Obx(() => Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            splashColor: none,
            onTap: () => showCalendar(Get.context!),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Space(width: 10),
                  _buildTextDateAndIcon(
                    text: homeController.startDate.value.tr,
                    iconData: Icons.arrow_right_alt,
                    iconColor: homeController.isSearch.value ? black : black,
                  ),
                  homeController.isSearch.value ? const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: IconWidget(icon: Icons.arrow_right_alt, color: black),
                  ) : Container(),
                  _buildTextDateAndIcon(
                    text: homeController.endDate.value.tr,
                    iconData: Icons.arrow_drop_down,
                    iconColor: homeController.isSearch.value ? none : black,
                  )
                ],
              ),
            ),
          ),
          homeController.isSearch.value ? Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: InkWell(
                splashColor: none,
                onTap: () {
                  homeController.startDate.value  = 'Start Date';
                  homeController.endDate.value = 'End Date';

                  homeController.isSearch.value = false;
                  homeController.clearData();
                  homeController.loadDriverReportData();
                },
                child: const IconWidget(icon: Icons.clear, color: red, size: 24),
            ),
          ) : Container(),
        ],
      ),
    ));
  }
  Widget _buildTextDateAndIcon({required String text, required IconData iconData, required Color iconColor, double size = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(text: text),
        const Space(),
        homeController.isSearch.value ? Container() : IconWidget(icon: iconData, color: iconColor, size: size),
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
        DateTimeRange _fromRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        _fromRange = value;

        DateTime rangeStart = DateFormat('yyyy-MM-dd').parse(_fromRange.start.toString());
        DateTime rangeEnd = DateFormat('yyyy-MM-dd').parse(_fromRange.end.toString());
        var outputFormat = DateFormat('dd-MMM-yy');
        var outputDateStart = outputFormat.format(rangeStart);
        var outputDateEnd = outputFormat.format(rangeEnd);

        var outputDay = DateFormat('d');
        var outputMonth = DateFormat('M');
        var outputYear = DateFormat('yy');
        var outputDayStart = outputDay.format(rangeStart);
        var outputMonthStart = outputMonth.format(rangeStart);
        var outputYearStart = outputYear.format(rangeStart);
        var outputDayEnd = outputDay.format(rangeEnd);
        var outputMonthEnd = outputMonth.format(rangeEnd);
        var outputYearEnd = outputYear.format(rangeEnd);
        homeController.dayStart = int.parse(outputDayStart);
        homeController.monthStart = int.parse(outputMonthStart);
        homeController.yearStart = int.parse(outputYearStart);
        homeController.dayEnd = int.parse(outputDayEnd);
        homeController.monthEnd = int.parse(outputMonthEnd);
        homeController.yearEnd = int.parse(outputYearEnd);

        debugPrint('outputDayStart : $outputDayStart');
        debugPrint('outputMonthStart : $outputMonthStart');
        debugPrint('outputYearStart : $outputYearStart');
        debugPrint('outputDayEnd : $outputDayEnd');
        debugPrint('outputMonthEnd : $outputMonthEnd');
        debugPrint('outputYearEnd : $outputYearEnd');


        homeController.startDate.value = outputDateStart;
        homeController.endDate.value = outputDateEnd;

        homeController.isSearch.value = true;
        homeController.loadDriverReportData();
      }
    });
  }

  Widget get _buildChart {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      color: lightGray,
      height: 250,
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
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: homeController.chartData.isNotEmpty ? HomeScreenBarChart(chartData: homeController.chartData) : FutureBuilder(
            future: _waite3Second(),
            builder: (context, snapshot) {
              return const TextWidget(text: 'No Data to show......');
            },
          ),
        ),
      ),
    );
  }

  Future<Widget> _waite3Second() async {
    await Future.delayed(const Duration(seconds: 3));
    return const CircularProgressIndicator();
  }

  Widget get _buildStatus {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(isTitle: true, text: 'States'.tr),
          _buildStatusItem,
        ],
      ),
    );
  }
  Widget get _buildStatusItem {
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
                subTitle: '${homeController.totalOnlineHour.value}h:${homeController.totalOnlineMinute.value}m',
              ),
              const Space(),
              _buildCardState(
                width: 100,
                iconData: Icons.directions_run,
                title: 'Distance'.tr,
                subTitle: '${homeController.totalDistance.value.toStringAsFixed(2)} km',
              ),
            ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCardState(
                width: 100,
                iconData: Icons.local_activity,
                title: 'Point'.tr,
                subTitle: '${homeController.totalPoint.value}',
              ),
              const Space(),
              _buildCardState(
                width: 100,
                iconData: Icons.motorcycle_rounded,
                title: 'Trip'.tr,
                subTitle: '${homeController.totalTrip.value}',
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
                subTitle: '${(homeController.totalCustomerRate.value / homeController.driverReportLength.value).toStringAsFixed(2)} / 5',
              ),
              const Space(),
              _buildCardState(
                width: 110,
                iconData: Icons.thumbs_up_down,
                title: 'Merchant'.tr,
                subTitle: '${(homeController.totalMerchantRate.value / homeController.driverReportLength.value).toStringAsFixed(2)} / 5',
              ),
            ],
          ),
        ],
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
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: white.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: _buildBreakDownItem(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBreakDownItem() {
    var totalEarning = homeController.totalDeliveryFee.value + homeController.totalBonus.value + homeController.totalTip.value;

    return Column(
      children: [
        _buildCardBreakDown(
          text: 'Net delivery fee'.tr,
          value: '\$${homeController.totalDeliveryFee.toStringAsFixed(2)}',
        ),
        _buildCardBreakDown(
          text: 'Bonus'.tr,
          value: '\$${homeController.totalBonus.toStringAsFixed(2)}',
        ),
        _buildCardBreakDown(
          text: 'Tip'.tr,
          value: '\$${homeController.totalTip.toStringAsFixed(2)}',
          isDotted: false,
        ),
        _buildCardBreakDown(
          text: 'Total Earning'.tr,
          value: '\$${totalEarning.toStringAsFixed(2)}',
          isNon: true,
        ),
      ],
    );
  }

  Widget _buildCardState({required double width, required IconData iconData, required String title, required String subTitle}) {
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

  Widget _buildCardBreakDown({required String text, required String value, bool isDotted = true, bool isNon = false}) {
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
    return isDot == true ? Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: DottedLine(
        dashLength: 1.5,
        lineThickness: 2,
        dashColor: silver.withOpacity(0.5),
      ),
    ) : Container(
      height: 1,
      color: silver.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
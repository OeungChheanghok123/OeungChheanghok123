import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/report_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: null,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 1,
              backgroundColor: white,
              expandedHeight: 630,
              excludeHeaderSemantics: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildDateMonthReport,
                      _buildChart,
                      _buildStatus,
                      _buildBreakDown,
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: _buildDetailBar,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildReportBody,
            ),
          ],
        ),
      ),
    );
  }


  Widget get _buildDateMonthReport{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => TextWidget(
                isTitle: true,
                text: reportController.dateMonthReport.value,
              ),
            ),
            const IconWidget(
              icon: Icons.arrow_drop_down_sharp,
              size: 20,
              color: black,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              const TextWidget(
                text: 'Total Earning: ',
                fontWeight: FontWeight.bold,
              ),
              TextWidget(
                text: '\$${reportController.totalEarning.value.toStringAsFixed(2)}',
                fontWeight: FontWeight.bold,
                color: rabbit,
              ),
            ],
          )
        ),
      ],
    );
  }
  Widget get _buildChart {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5),
      color: white,
      height: 180,
      child: HomeScreenBarChart(data: reportController.data),
    );
  }
  Widget get _buildStatus {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            isTitle: true,
            text: 'Stats',
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildColumnStats(
                        'Online',
                        reportController.reportModel.value.online,
                      ),
                    ),
                    Obx(
                      () => _buildColumnStats(
                        'Distance',
                        reportController.reportModel.value.distance,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildColumnStats(
                        'Trips',
                        reportController.reportModel.value.trips.toString(),
                      ),
                    ),
                    Obx(
                      () => _buildColumnStats(
                        'Customer',
                        reportController.reportModel.value.customerRating,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _buildColumnStats(
                        'Points',
                        reportController.reportModel.value.points.toString(),
                      ),
                    ),
                    Obx(
                      () => _buildColumnStats(
                        'Merchant',
                        reportController.reportModel.value.merchantRating,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          isTitle: true,
          text: 'Breakdown',
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Obx(
                () => _buildColumnBreakdown(
                  'Net delivery fee',
                  '\$${reportController.reportModel.value.deliveryFee.toStringAsFixed(2)}',
                ),
              ),
              Obx(
                () => _buildColumnBreakdown(
                  'Bonus',
                  '\$${reportController.reportModel.value.bonus.toStringAsFixed(2)}',
                ),
              ),
              Obx(
                () => _buildColumnBreakdown(
                  'tip',
                  '\$${reportController.reportModel.value.tip.toStringAsFixed(2)}',
                  dotLine: false,
                ),
              ),
              Obx(
                () => _buildColumnBreakdown(
                  'Total Earning',
                  '\$${reportController.totalEarning.toStringAsFixed(2)}',
                  noneLine: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget get _buildDetailBar{
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: const TextWidget(
                  text: 'Fitter by Date:',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed('/'),
                child: const IconWidget(
                  icon: Icons.calendar_today,
                  size: 20,
                  color: black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(
                () => _buildRadioStatusBar(
                  1,
                  'Canceled',
                  reportController.colorTextCanceledStatus.value,
                  reportController.colorRadioCanceledStatus.value,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 1,
                height: 15,
                color: black,
              ),
              Obx(
                () => _buildRadioStatusBar(
                  2,
                  'Delivered',
                  reportController.colorTextDeliveredStatus.value,
                  reportController.colorRadioDeliveredStatus.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget get _buildReportBody{
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reportController.orderWeek.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: [
              Obx(() => _buildDateAndTotalEarning(index),),
              _buildItemOrder,
            ],
          );
        },
      ),
    );
  }
  Widget get _buildItemOrder{
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reportController.orderNo.length,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: [
              InkWell(
                splashColor: none,
                onTap: () => Get.toNamed('/report_order_detail?titleOrder=${reportController.orderNo[index]}'),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 0,
                          child: TextWidget(text: '${index+1}. '),
                        ),
                        Expanded(
                          flex: 5,
                          child: TextWidget(
                            text: 'Order #: ${reportController.orderNo[index]}, your earning',
                          ),
                        ),
                        Obx(() => Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                            color: reportController.isDelivered.value ? rabbit : carrot,
                            child: const TextWidget(text: '\$12.00', fontWeight: FontWeight.bold, color: white,),
                          ),
                        ),),
                      ],
                    ),
                    const Space(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 0,
                          child: TextWidget(text: '${index+1}. ', color: none),
                        ),
                        const Expanded(
                          flex: 2,
                          child: TextWidget(
                              text: 'From Cafe Amazon (PPIU) to Sovongdy', size: 10, color: silver
                          ),
                        ),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildIconAndText(Icons.directions_bike_outlined, silver, '1.2km', 9),
                                const Space(),
                                _buildIconAndText(Icons.watch_later, silver, '20min', 9),
                                const Space(),
                              ],
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const DottedLine(
                  dashLength: 1.5,
                  lineThickness: 2,
                  dashColor: silver,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateAndTotalEarning(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: reportController.orderWeek[index],
              fontWeight: FontWeight.bold,
              color: reportController.isCanceled.value ? carrot : reportController.isDelivered.value ? black : rabbit,
            ),
            const TextWidget(text: 'Total Earning = \$50.00'),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          height: 1.5,
          color: silver,
        ),
      ],
    );
  }
  Widget _buildColumnStats(String text, String value, {double height = 15}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: text),
        Container(
          margin: const EdgeInsets.only(left: 1.5, top: 5),
          child:TextWidget(
            text: value,
            fontWeight: FontWeight.bold,
          ),
        ),
        Space(height: height),
      ],
    );
  }
  Widget _buildColumnBreakdown(String text, String value, {bool dotLine = true, noneLine = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: text),
            noneLine ? Container(
              color: rabbit,
              padding: const EdgeInsets.only(left: 2),
              child: TextWidget(text: value, color: white, fontWeight: FontWeight.bold),
            ) : TextWidget(text: value),
          ],
        ),
        noneLine ? const SizedBox.shrink() : dotLine ? Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: const DottedLine(
            dashLength: 1.5,
            lineThickness: 2,
            dashColor: silver,
          ),
        ) : Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 1,
          color: silver,
        ),
      ],
    );
  }
  Widget _buildRadioStatusBar(int index, String text, Color textColor, Color radioColor) {
    return InkWell(
      splashColor: none,
      onTap: () => reportController.radioButtonBar(index),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: silver, width: 1.5),
            ),
            child: Container(
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: radioColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          TextWidget(
            text: text,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
  Widget _buildIconAndText(IconData iconData, Color color, String text, double textSize){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconWidget(icon: iconData, color: color, size: 12),
        const Space(width: 1),
        TextWidget(text: text, color: color, size: textSize),
      ],
    );
  }
}
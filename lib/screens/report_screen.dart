import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/report_controller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/order_report_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/home_screen_bar_chart.dart';

class ReportScreen extends StatefulWidget{
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>{
  ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        appBar: null,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(OrderReportModel.collectionName).snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasError){
              return TextWidget(text: "${snapshot.error}");
            } else {
              if (snapshot.hasData){
                return CustomScrollView(
                  slivers: [
                    _buildSilverAppBar(snapshot.data!.docs),
                    SliverToBoxAdapter(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection(OrderModel.collectionName).orderBy(OrderModel.dateTimeString, descending: true).snapshots(),
                        builder: (context, snapshot){
                          if (snapshot.hasData){
                            return _buildReportBody(snapshot.data!.docs);
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
                  ],
                );
              } else{
                return Container(
                  height: MediaQuery.of(context).size.height - 55,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: rabbit),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildSilverAppBar(List<DocumentSnapshot> documents){
    List<OrderReportModel> modelList = documents.map((data) => OrderReportModel.fromSnapshot(data)).toList();

    return SliverAppBar(
      pinned: true,
      elevation: 1,
      backgroundColor: lightGray,
      expandedHeight: 670,
      excludeHeaderSemantics: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            children: [
              _buildDateMonthReport,
              _buildTotalEarning(modelList[0]),
              _buildChart,
              _buildStatus(modelList[0]),
              _buildBreakDown(modelList[0]),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: _buildDetailBar,
      ),
    );
  }

  Widget get _buildDateMonthReport{
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 15, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => TextWidget(
            isTitle: true,
            text: reportController.dateMonthReport.value,
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
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
          child: HomeScreenBarChart(data: reportController.data),
        ),
      ),
    );
  }
  Widget _buildTotalEarning(OrderReportModel reportModel){
    double totalEarning = double.parse(reportModel.deliveryFee) + double.parse(reportModel.bonus) + double.parse(reportModel.tip) ;

    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
        child: Row(
          children: [
            const IconWidget(icon: Icons.monetization_on, size: 20,),
            const Space(),
            const TextWidget(
              text: 'Total Earning: ',
              fontWeight: FontWeight.bold,
            ),
            TextWidget(
              text: '\$${totalEarning.toStringAsFixed(2)}',
              fontWeight: FontWeight.bold,
              color: rabbit,
            ),
          ],
        )
    );
  }
  Widget _buildStatus(OrderReportModel reportModel) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            isTitle: true,
            text: 'Stats'.tr,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      width: 105,
                      iconData: Icons.access_time,
                      title: 'Online',
                      subTitle: reportModel.online,
                    ),
                    const Space(),
                    _buildCard(
                      width: 105,
                      iconData: Icons.directions_run,
                      title: 'Distance',
                      subTitle: reportModel.distance,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      width: 105,
                      iconData: Icons.local_activity,
                      title: 'Point',
                      subTitle: reportModel.point,
                    ),
                    const Space(),
                    _buildCard(
                      width: 105,
                      iconData: Icons.motorcycle_rounded,
                      title: 'Trip',
                      subTitle: reportModel.trip,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      width: 105,
                      iconData: Icons.thumbs_up_down,
                      title: 'Customer',
                      subTitle: reportModel.customerRating,
                    ),
                    const Space(),
                    _buildCard(
                      width: 105,
                      iconData: Icons.thumbs_up_down,
                      title: 'Merchant',
                      subTitle: reportModel.merchantRating,
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
  Widget _buildBreakDown(OrderReportModel reportModel) {
    double totalEarning = double.parse(reportModel.deliveryFee) + double.parse(reportModel.bonus) + double.parse(reportModel.tip) ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          isTitle: true,
          text: 'Breakdown'.tr,
        ),
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
                  _buildColumnBreakdown(
                    'Net delivery fee',
                    '\$${double.parse(reportModel.deliveryFee).toStringAsFixed(2)}',
                  ),
                  _buildColumnBreakdown(
                    'Bonus',
                    '\$${double.parse(reportModel.bonus).toStringAsFixed(2)}',
                  ),
                  _buildColumnBreakdown(
                    'tip',
                    '\$${double.parse(reportModel.tip).toStringAsFixed(2)}',
                    dotLine: false,
                  ),
                  _buildColumnBreakdown(
                    'Total Earning',
                    '\$${totalEarning.toStringAsFixed(2)}',
                    noneLine: true,
                  ),
                ],
              ),
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
              Obx(() => InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((DateTime? value) {
                    if (value != null) {
                      DateTime _fromDate = DateTime.now();
                      _fromDate = value;
                      var outputFormat = DateFormat('dd MMM');
                      final String date = outputFormat.format(_fromDate);
                      reportController.dataDatePicker.value = date;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected date: $date')),
                      );
                    }
                  });
                },
                child: reportController.dataDatePicker.value == '' ? const IconWidget(
                  icon: Icons.calendar_today,
                  size: 20,
                  color: black,
                ) : TextWidget(text: reportController.dataDatePicker.value),
              ),),
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
  Widget _buildReportBody(List<DocumentSnapshot> documents){
    List<OrderModel> orderList = documents.map((data) => OrderModel.fromSnapshot(data)).toList();
    List<DeliverModel> deliverList = documents.map((data) => DeliverModel.fromSnapshot(data)).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return Column(
            children: [
              _buildDateAndTotalEarning(orderList[index], deliverList[index]),
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (BuildContext context, int index){
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection(DeliverModel.collectionName).snapshots(),
                      builder: (context, snapshot1){
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(CustomerModel.collectionName).snapshots(),
                          builder: (context, snapshot2){

                            List<CustomerModel> cusList = getCustomerFromSnapshot(snapshot2.data!.docs);

                            if (snapshot1.hasData && snapshot2.hasData){
                              return _buildItemOrder(index, orderList[index], cusList, snapshot1.data!.docs);
                            } else {
                              return Container(
                                height: MediaQuery.of(context).size.height - 55,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(color: rabbit),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildItemOrder(int index, OrderModel orderModel, List<CustomerModel> cusModel, List<DocumentSnapshot> documents){
    List<DeliverModel> deliverList = documents.map((data) => DeliverModel.fromSnapshot(data)).toList();

    return Card(
      elevation: 1,
      borderOnForeground: false,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        splashColor: none,
        onTap: () => Get.toNamed('/report_order_detail?titleOrder=${orderModel.orderId}'),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: TextWidget(text: '${index + 1}. '),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        TextWidget(text: 'Order ${orderModel.orderId}'),
                        TextWidget(text: '  ${orderModel.dateTime}', size: 10, color: silver,),
                      ],
                    ),
                  ),
                  _buildDeliverFee(deliverList[index]),
                ],
              ),
              const Space(),
              Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: TextWidget(text: '${index + 1}. ', color: none),
                  ),
                  _buildCustomerAndMerChant(cusModel[0]),
                  _buildDistanceAndTime(deliverList[index]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDistanceAndTime(DeliverModel deliverModel){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildIconAndText(
            iconData: Icons.directions_bike_outlined,
            text: deliverModel.distance,
          ),
          _buildIconAndText(
            iconData: Icons.watch_later,
            text: deliverModel.time,
          ),
        ],
      ),
    );
  }
  Widget _buildCustomerAndMerChant(CustomerModel customerModel){
    return Expanded(
      flex: 2,
      child: TextWidget(
        text: '${customerModel.gender} to ${customerModel.customerName}', size: 10, color: text, fontWeight: FontWeight.w500,
      ),
    );
  }
  Widget _buildDeliverFee(DeliverModel deliverModel){
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        decoration: BoxDecoration(
          color: reportController.isDelivered.value ? rabbit.withOpacity(0.5) : carrot.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextWidget(
          text: '\$${double.parse(deliverModel.deliveryFee).toStringAsFixed(2)}',
          size: 11,
          fontWeight: FontWeight.w600,
          color: black.withOpacity(0.8),
        ),
      ),
    );
  }
  Widget _buildDateAndTotalEarning(OrderModel orderModel, DeliverModel deliverModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => TextWidget(
              text: orderModel.dateTime,
              fontWeight: FontWeight.bold,
              color: reportController.isCanceled.value ? carrot : reportController.isDelivered.value ? black : rabbit,
            ),),
            const TextWidget(text: 'Total Earning = \$1'),
            // TextWidget(text: 'Total Earning = \$${double.parse(deliverModel.deliveryFee).toStringAsFixed(2)}'),
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
  Widget _buildCard({required double width, required IconData iconData, required String title, required String subTitle}) {
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
        width: width,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconWidget(icon: iconData, size: 24,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(text: title, size: 10,),
                const Space(),
                TextWidget(text: subTitle, fontWeight: FontWeight.bold, color: rabbit, size: 10,),
              ],
            ),
          ],
        ),
      ),
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
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: rabbit.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextWidget(text: value, color: black.withOpacity(0.8), fontWeight: FontWeight.bold,),
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
  Widget _buildIconAndText({required IconData iconData, required String text}){
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconWidget(icon: iconData, color: silver, size: 12,),
          const Space(width: 1),
          TextWidget(text: text, color: silver, size: 9),
        ],
      ),
    );
  }
}
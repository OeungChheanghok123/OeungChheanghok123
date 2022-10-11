import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/controllers/report_controller.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/new_order_card.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);

  final controller = Get.put(ReportController());
  final newOrderController = Get.put(NewOrderCardController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        body: FutureBuilder(
          future: homeController.wait3SecAndLoadData(),
          builder: _buildFunctionBody,
        ),
        bottomSheet: Obx(() => newOrderController.newOrderId.value != '' && homeController.isOnline.value == true ? NewOrderCard() : const SizedBox()),
      ),
    );
  }
  Widget _buildFunctionBody(BuildContext context, AsyncSnapshot<Widget> snapshot) {
    if (snapshot.hasError) {
      return TextWidget(text: "${snapshot.error}");
    } else if (snapshot.hasData) {
      return _buildBody;
    } else {
      return Container(
        height: MediaQuery.of(context).size.height - 55,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: rabbit),
      );
    }
  }

  Widget get _buildBody {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            _buildDetailBar,
            _buildOrderBodyWidget,
          ],
        ),
      ),
    );
  }

  Widget get _buildDetailBar {
    final context  = Get.context;
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
            onTap: () => controller.showCalender(context!),
            child: Container(
              padding: const EdgeInsets.all(0),
              child: controller.dataDatePicker.value == '' ? const IconWidget(
                icon: Icons.calendar_today,
                size: 20,
                color: black,
              ) : TextWidget(text: controller.dataDatePicker.value),
            ),
          ),),
          Obx(() => InkWell(
            onTap: () => controller.deleteFilter(),
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              child: controller.dataDatePicker.value != '' ? const IconWidget(
                icon: Icons.delete,
                size: 24,
                color: black,
              ) : Container(),
            ),
          ),),
        ],
      ),
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
        final report = controller.orderData.data;
        return controller.isHasData.value ? ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report!.length,
          itemBuilder: orderBodyItem,
        ) : noDataShow;
      }
    });
  }

  Widget get noDataShow {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: TextWidget(
        text: 'Your Order on ${controller.dataDatePicker.value} is empty.\nPlease try choose day',
        color: black.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        size: 14,
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget orderBodyItem(BuildContext context, int index) {
    final order = controller.orderData.data![index];
    final deliver = controller.deliverData.data![index];
    return _buildOrderBodyItemWidget(order, deliver);
  }
  Widget _buildOrderBodyItemWidget(OrderModel orderModel, DeliverModel deliverModel) {
    var yourEarning = double.parse(deliverModel.deliveryFee) + double.parse(deliverModel.tip) + double.parse(deliverModel.bonus);
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        children: [
          // date and process
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Date: ${orderModel.date}  ',
                fontWeight: FontWeight.bold,
                color: black,
              ),
              TextWidget(
                text: orderModel.time,
                size: 10,
                fontWeight: FontWeight.w500,
                color: black.withOpacity(0.5),
              ),
              const Spacer(),
              TextWidget(
                text: deliverModel.process,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          // horizontail line
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            height: 1.5,
            color: silver,
          ),
          // detail card
          InkWell(
            onTap: () => controller.cardOrderPage(orderModel.orderId, deliverModel.deliveryFee, deliverModel.tip, deliverModel.bonus, orderModel.customerName),
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
                          text: 'Your Earning: '.tr,
                          size: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 3,
                          ),
                          decoration: BoxDecoration(
                            color: rabbit.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextWidget(
                            text: '\$${yourEarning.toStringAsFixed(2)}',
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
                          text: '${orderModel.merchantName} ' + 'to'.tr + ' ${orderModel.customerName}',
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

  Widget _buildCard({required Widget child, EdgeInsetsGeometry margin = const EdgeInsets.all(0)}) {
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

  Widget _buildIconAndText({required int index, required IconData iconData, required String text}) {
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
          index == 1 ? TextWidget(text: '$text Km', color: silver, size: 9) : TextWidget(text: '$text min', color: silver, size: 9),
        ],
      ),
    );
  }
}
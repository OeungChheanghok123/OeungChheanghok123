import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/google_map_controller.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class NewOrderCard extends StatelessWidget {
  NewOrderCard({Key? key}) : super(key: key);

  final newOrderController = Get.put(NewOrderCardController());
  final mapController = Get.put(MapController());
  final orderController = Get.put(OrderController());

  final List<BoxShadow> boxShadowList = [
    BoxShadow(
      color: silver.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Stack(
        children: [
          cardOrder,
          timerWidget,
        ],
      ),
    );
  }

  Widget get cardOrder {
    return Obx(() {
      final merchantStatus = newOrderController.merchantData.status;
      final customerStatus = newOrderController.customerData.status;
      final deliverStatus = newOrderController.deliverData.status;

      if (merchantStatus == RemoteDataStatus.processing && customerStatus == RemoteDataStatus.processing && deliverStatus == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      }
      else if (merchantStatus == RemoteDataStatus.success && customerStatus == RemoteDataStatus.success && deliverStatus == RemoteDataStatus.success) {
        return Container(
          height: 260,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: boxShadowList,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileMerchantWidget,
              _buildSpace,
              _buildProfileCustomerWidget,
              _buildHorizontailLine,
              _buildRowDetailOrderWidget,
              _buildButtonOrder,
            ],
          ),
        );
      }
      else  {
        return ScreenWidgets.error;
      }
    });
  }

  Widget get timerWidget {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: carrot,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Obx(
            () => TextWidget(
              text: '${newOrderController.startCounter.value}',
              size: 9,
              color: white,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildProfileMerchantWidget {
    return Obx(() {
      final report = newOrderController.merchantData.data!;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: report.length,
        itemBuilder: _buildProfileMerchantItemWidget,
      );
    });
  }
  Widget _buildProfileMerchantItemWidget(BuildContext context, int index) {
    final merchant = newOrderController.merchantData.data![index];
    return profileMerchantItem(merchant);
  }
  Widget profileMerchantItem(MerchantModel merchantModel) {
    return _buildDetailProfile(
      imageString: merchantModel.image,
      labelString: 'merchant logo',
      status: 'From',
      titleString: merchantModel.merchantName,
      detailString: merchantModel.location,
    );
  }

  Widget get _buildSpace {
    return const Space(height: 20);
  }

  Widget get _buildProfileCustomerWidget {
    return Obx(() {
      final report = newOrderController.customerData.data!;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: report.length,
        itemBuilder: _buildProfileCustomerItemWidget,
      );
    });
  }
  Widget _buildProfileCustomerItemWidget(BuildContext context, int index) {
    final customer = newOrderController.customerData.data![index];
    return profileCustomerItem(customer);
  }
  Widget profileCustomerItem(CustomerModel customerModel) {
    return _buildDetailProfile(
      imageString: customerModel.image,
      labelString: 'user logo',
      status: 'To',
      titleString: customerModel.customerName,
      detailString: customerModel.location,
    );
  }

  Widget get _buildHorizontailLine {
    return Container(
      height: 1,
      width: double.infinity,
      color: silver,
      margin: const EdgeInsets.only(top: 10),
    );
  }

  Widget get _buildRowDetailOrderWidget {
    return Obx(() {
      final report = newOrderController.deliverData.data!;
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: report.length,
        itemBuilder: _buildRowDetailOrderItemWidget,
      );
    });
  }
  Widget _buildRowDetailOrderItemWidget(BuildContext context, int index) {
    final deliver = newOrderController.deliverData.data![index];
    return rowDetailOrderItem(deliver);
  }
  Widget rowDetailOrderItem(DeliverModel deliverModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconAndText(
          icon: Icons.access_time,
          title: '${deliverModel.period} min',
        ),
        _buildIconAndText(
          icon: Icons.directions_bike,
          title: '${double.parse(deliverModel.distance).toStringAsFixed(1)} km',
        ),
        _buildIconAndText(
          icon: Icons.monetization_on,
          title: '\$${double.parse(deliverModel.deliveryFee).toStringAsFixed(2)}',
          color: rabbit,
        ),
        _buildIconAndText(
          icon: Icons.tips_and_updates,
          title: 'Tip = \$${double.parse(deliverModel.tip).toStringAsFixed(2)}',
          showLine: false,
        ),
      ],
    );
  }

  Widget get _buildButtonOrder {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            buttonText: 'Reject'.tr,
            color: red,
            onPressed: () => newOrderController.showDialogReject(),
          ),
          _buildButton(
            buttonText: 'Accept'.tr,
            color: succeed,
            onPressed: () {
              orderController.orderAccept.value = true;
              orderController.getOrderNo.value = newOrderController.orderId.value;

              newOrderController.setDriverId();
              newOrderController.closeTimer();
              newOrderController.updateOrderStatus();
              mapController.getCurrentCameraPosition();
              mapController.loadOrderData();
              Get.toNamed('/order_accept');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailProfile({required String imageString, required String labelString, required String status, required String titleString, required String detailString}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: rabbit,
            borderRadius: BorderRadius.circular(100),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imageString),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(
                  text: status,
                  size: 14,
                  color: silver,
                ),
                _buildText(
                  text: titleString,
                  size: 12,
                  color: black,
                ),
                _buildText(
                  text: detailString,
                  size: 11,
                  color: black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText({required String text, required Color color, required double size}) {
    return TextWidget(
      text: text,
      size: size,
      color: color,
      textOverflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildIconAndText({required IconData icon, required String title, Color color = black, bool showLine = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          showLine
              ? IconWidget(
            icon: icon,
            size: 20,
            color: color,
          )
              : const SizedBox.shrink(),
          showLine ? const SizedBox(width: 5) : const SizedBox.shrink(),
          TextWidget(
            text: title,
            color: color,
            size: 11,
          ),
          showLine
              ? Container(
            width: 1,
            height: 15,
            color: black,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildButton({required String buttonText, required Color color, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ButtonWidget(
        onPressed: onPressed,
        width: 130,
        color: color,
        borderSide: BorderSide.none,
        child: TextWidget(
          text: buttonText,
          fontWeight: FontWeight.w500,
          color: white,
        ),
      ),
    );
  }
}
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_detail_contrller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({Key? key}) : super(key: key);

  final controller = Get.put(OrderDetailController());

  @override
  Widget build(BuildContext context) {
    //controller.onInit();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          _buildDetailCustomer,
          _buildItemCountAndTotal,
          _buildTextFieldRemark,
          _buildItemsOrderDetail,
          _buildStatusDetail,
          _buildYourEarning,
          _buildButtonStatus,
        ],
      ),
    );
  }

  Widget get _buildDetailCustomer{
    return Obx(() {
      final status = controller.customerData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.customerData.data;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report!.length,
          itemBuilder: (context, index) {
            final customer = controller.customerData.data![index];
            return customerDetailItem(customer);
          },
        );
      }
    });
  }
  Widget customerDetailItem(CustomerModel customerModel) {
    return Container(
      color: lightGray,
      padding: const EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                profileCustomer(customerModel.image),
                detailCustomer(customerModel.customerName, customerModel.location),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: iconCall,
          ),
        ],
      ),
    );
  }
  Widget profileCustomer(String image) {
    return Expanded(
      flex: 0,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: rabbit,
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
  Widget detailCustomer(String name, String address) {
    return Expanded(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: name),
            const Space(),
            TextWidget(text: address),
          ],
        ),
      ),
    );
  }
  Widget get iconCall {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: rabbit,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const IconWidget(
            icon: Icons.call,
            color: white,
            size: 25,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: none,
              image: DecorationImage(
                image: AssetImage('assets/image/smart_icon.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildItemCountAndTotal{
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 15,  left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => TextWidget(text: '${controller.itemLength.value} items - Collect money (exclude Tip and Bonus)')),
          Obx(() => Container(
            decoration: BoxDecoration(
              color: rabbit,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextWidget(
                text: ' \$ ${controller.total.value.toStringAsFixed(2)} ',
                color: white,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ],
      ),
    );
  }
  Widget get _buildTextFieldRemark{
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Remarks:',
            color: silver,
            fontWeight: FontWeight.bold,
          ),
          TextFieldWidget(
            controller: controller.remarkController,
            height: 45,
            inputType: TextInputType.text,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget get _buildItemsOrderDetail{
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 15, left: 15),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'items',
            color: rabbit,
          ),
          _buildListProducts,
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: double.infinity,
            height: 1,
            color: silver,
          ),
        ],
      ),
    );
  }
  Widget get _buildListProducts{
    return Obx(() {
      final status = controller.productData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.listProductName.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextWidget(text: '${index + 1}. '),
                            TextWidget(text: controller.listProductName[index]),
                          ],
                        ),
                        TextWidget(text: '\$${controller.listAmount[index].toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget(text: '${index+1}. ', color: none,),
                        TextWidget(text: '${controller.listQty[index]} X \$${controller.listSalePrice[index]}', color: silver,),
                      ],
                    ),
                    index == controller.listProductName.length - 1 ? const SizedBox.shrink() : Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const DottedLine(
                        dashLength: 1.5,
                        lineThickness: 2,
                        dashColor: silver,
                      ),
                    ),
                  ],
                )
            );
          },
        );
      }
    });
  }

  Widget get _buildStatusDetail{
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        children: [
          Obx(() => _buildItemsStatus('Subtotal', '\$${controller.subTotal.value.toStringAsFixed(2)}')),
          _buildItemsStatus('Discount', '\$0.00'),
          _buildItemsStatus('VAT', '\$0.00', dottedLine: true),
          Obx(() => _buildItemsStatus('Net delivery fee', '\$${controller.getDeliveryFee.value}', fontBold: true)),
          Obx(() => _buildItemsStatus('Tip', '\$${controller.getTip.value}', fontBold: true)),
          Obx(() => _buildItemsStatus('Bonus', '\$${controller.getBonus.value}', fontBold: true, underLine: true)),
          Obx(() => _buildItemsStatus('Total', '\$${controller.totalEarning.value.toStringAsFixed(2)}')),
        ],
      ),
    );
  }
  Widget get _buildYourEarning{
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextWidget(
            text: 'Your Earnings',
            fontWeight: FontWeight.bold,
          ),
          Container(
            color: rabbit,
            padding: const EdgeInsets.all(3),
            child: Obx(() => TextWidget(
              text: '\$${controller.yourEarning.value.toStringAsFixed(2)}',
              color: white,
              fontWeight: FontWeight.bold,
            )),
          ),
        ],
      ),
    );
  }
  Widget get _buildButtonStatus{
    return  Container(
      color: white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ButtonWidget(
        onPressed: () => Get.toNamed('/order_accept'),
        width: double.infinity,
        child:const TextWidget(
          text: 'Tap to view the map',
          color: white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemsStatus(String title, String price, {bool fontBold = false, dottedLine = false, underLine = false}){
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: title,
                fontWeight: fontBold ? FontWeight.bold : FontWeight.normal,
              ),
              TextWidget(
                text: price,
                fontWeight: fontBold ? FontWeight.bold : FontWeight.normal,
              ),
            ],
          ),
          underLine ? Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 1,
            color: silver,
          ) : dottedLine ? Container(
            margin: const EdgeInsets.only(top: 5),
            child: const DottedLine(
              dashLength: 1.5,
              lineThickness: 2,
              dashColor: silver,
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

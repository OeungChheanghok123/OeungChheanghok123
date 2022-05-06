import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/report_order_detail_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class ReportOrderDetailScreen extends StatefulWidget {
  const ReportOrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<ReportOrderDetailScreen> createState() => _ReportOrderDetailScreenState();
}

class _ReportOrderDetailScreenState extends State<ReportOrderDetailScreen> {

  ReportOrderDetailController reportOrderDetailController = Get.put(ReportOrderDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar:  AppBar(
          backgroundColor: white,
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          title: TitleAppBarWidget(
            text: 'Order ID: ${Get.parameters['titleOrder']}',
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailCustomer,
              _buildItemCountAndTotal,
              _buildTextFieldRemark,
              _buildItemsOrderDetail,
              _buildStatusDetail,
              _buildYourEarning,
              _buildButtonStatus,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildDetailCustomer{
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
                Expanded(
                  flex: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: rabbit,
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(reportOrderDetailController.customer.image),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: reportOrderDetailController.customer.name),
                        const Space(),
                        TextWidget(text: reportOrderDetailController.customer.address),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Stack(
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
                      )
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
  Widget get _buildItemCountAndTotal{
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 15,  left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextWidget(text: '5 items - Collect money (exclude tip)'),
          Container(
            color: rabbit,
            child: const TextWidget(
              text: '\$19.00',
              color: white,
              fontWeight: FontWeight.w500,
            ),
          ),
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
            controller: reportOrderDetailController.remarkController,
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
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
                            TextWidget(text: '${index+1}. '),
                            TextWidget(text: 'Product ${index+1}'),
                          ],
                        ),
                        const TextWidget(
                          text: '\$3.00',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextWidget(text: '${index+1}. ', color: none,),
                        const TextWidget(text: '1 X \$3.00', color: silver,),
                      ],
                    ),
                    index == 4 ? const SizedBox.shrink() : Container(
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
          ),
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
  Widget get _buildStatusDetail{
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        children: [
          _buildItemsStatus('Subtotal', '\$15.00'),
          _buildItemsStatus('Discount', '\$0.00'),
          _buildItemsStatus('VAT', '\$0.00', dottedLine: true),
          _buildItemsStatus('Net delivery fee', '\$4.00', fontBold: true),
          _buildItemsStatus('Tip', '\$1.00', fontBold: true),
          _buildItemsStatus('Bonus', '\$0.00', fontBold: true, underLine: true),
          _buildItemsStatus('Total', '\$20.00'),
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
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: const TextWidget(
              text: '\$5.00',
              color: white,
              fontWeight: FontWeight.bold,
            ),
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
        onPressed: () => Get.back(),
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: const TextWidget(
          text: 'Delivered successfully to Sovongdy',
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
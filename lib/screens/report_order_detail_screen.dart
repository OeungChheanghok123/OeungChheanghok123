import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/report_order_detail_controller.dart';
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
              _buildItemsDetail,
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
          ),
        ],
      ),
    );
  }
  Widget get _buildItemsDetail{
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
}
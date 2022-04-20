import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/support_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/svg_picture_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportController supportController = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: lightGray,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            splashColor: none,
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: supportController.titleText),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCardNumber,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildCardNumber {
    return Card(
      color: white,
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          children: [
            const TextWidget(
              isTitle: true,
              text: 'Call Now',
            ),
            _buildPhoneNumber(
              supportController.smartImage,
              supportController.smartNumber,
            ),
            _buildPhoneNumber(
              supportController.cellcardImage,
              supportController.cellcardNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumber(String image, String phoneNumber) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 25,
            height: 20,
            child: SvgPictureWidget(
              imageString: image,
              label: 'Smart Number: $phoneNumber',
            ),
          ),
          TextWidget(text: phoneNumber, size: 14),
        ],
      ),
    );
  }
}

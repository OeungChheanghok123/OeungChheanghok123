import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/verify_phone_number_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  VerifyPhoneNumberScreen({Key? key}) : super(key: key);

  final controller = Get.put(VerifyPhoneNumberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: white,
      appBar: null,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Container(
      width: size.width,
      height: size.height,
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        children: [
          _buildLayout(1, const SizedBox()),
          _buildLayout(5, _buildBodyWidget),
        ],
      ),
    );
  }
  Widget get _buildBodyWidget {
    return Column(
      children: [
        _buildImageLock,
        const TextWidget(
          isTitle: true,
          text: 'Verify Phone Number',
        ),
        Container(
          width: 250,
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: const TextWidget(
            textAlign: TextAlign.center,
            text: 'Enter your mobile phone number to receive one-time password (OTP)',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 48,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: black.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: TextWidget(
                  text: "+855",
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildTextFieldPhoneNumber,
          ],
        ),
        _buildButtonNext,
      ],
    );
  }
  Widget get _buildImageLock {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: rabbit,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Center(
        child: IconWidget(
          icon: Icons.lock_open_outlined,
          color: white,
          size: 24,
        ),
      ),
    );
  }
  Widget get _buildTextFieldPhoneNumber {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFieldWidget(
        controller: controller.phoneController,
        height: 50,
        inputType: TextInputType.phone,
        hintText: 'Enter phone number',
        isPrefixIcon: true,
        prefixIcon: const Icon(Icons.phone, size: 20, color: rabbit),
      ),
    );
  }
  Widget get _buildButtonNext {
    return ButtonWidget(
      onPressed: () {
        controller.loadAllPhoneNumber();
        debugPrint('phone number is ${controller.phoneController.text}');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          TextWidget(
            text: 'Next',
            color: white,
            size: 14,
            fontWeight: FontWeight.w500,
          ),
          Space(),
          IconWidget(
            icon: Icons.double_arrow,
            color: white,
          ),
        ],
      ),
    );
  }

  Widget _buildLayout(int index, Widget widget) {
    return Expanded(
      flex: index,
      child: Container(
        width: double.infinity,
        color: white,
        child: widget,
      ),
    );
  }
}
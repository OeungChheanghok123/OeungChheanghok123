import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  const VerifyPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      backgroundColor: white,
      appBar: null,
      body: Container(
        width: size.width,
        height: size.height,
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: Column(
          children: [
            _buildLayout(1, SizedBox(key: key)),
            _buildLayout(5, _buildBody),
          ],
        ),
      ),
    );
  }

  Widget get _buildBody {
    TextEditingController controller = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: rabbit,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            key: key,
            child: IconWidget(
              key: key,
              icon: Icons.lock_open_outlined,
              color: white,
              size: 24,
            ),
          ),
        ),
        TextWidget(
          key: key,
          isTitle: true,
          text: 'Verify Phone Number',
        ),
        Container(
          width: 250,
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: TextWidget(
            key: key,
            textAlign: TextAlign.center,
            text: 'Enter your mobile phone number to receive one-time password (OTP)',
          ),
        ),
        Container(
          width: 250,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFieldWidget(
            controller: controller,
            height: 50,
            inputType: TextInputType.number,
            borderRadius: 20,
            hintText: 'Enter your phone number',
            isPrefixIcon: true,
            prefixIcon: const Icon(Icons.phone, size: 20, color: rabbit),
          ),
        ),
        ButtonWidget(
          onPressed: () => Get.offAllNamed('/enter_otp_code?phone=${controller.text}'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextWidget(
                text: 'Next',
                color: white,
                size: 14,
                fontWeight: FontWeight.w500,
              ),
              Space(key: key),
              const IconWidget(
                icon: Icons.double_arrow,
                color: white,
              ),
            ],
          ),
        ),
      ],
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
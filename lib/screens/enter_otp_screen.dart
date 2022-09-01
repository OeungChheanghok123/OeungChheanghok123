import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/enter_otp_code_controller.dart';
import 'package:loy_eat/controllers/verify_phone_number_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';


class EnterOTPCodeScreen extends StatelessWidget {
  EnterOTPCodeScreen({Key? key}) : super(key: key);

  final otpCodeController = Get.put(OTPCodeController());
  final verifyPhoneNumberController = Get.put(VerifyPhoneNumberController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: white,
      appBar: null,
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLayout(1, Container()),
            _buildLayout(5,  Container(
              width: size.width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
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
                  ),
                  const TextWidget(
                    isTitle: true,
                    text: 'Enter Code',
                  ),
                  Container(
                    width: 250,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: TextWidget(
                      textAlign: TextAlign.center,
                      text: 'Enter your one-time password (OTP) sent to +855${verifyPhoneNumberController.phoneNumber}',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => TextWidget(
                          text: 'Expire in ${otpCodeController.start.value} seconds. ',
                          color: silver,
                        )),
                        InkWell(
                          onTap: () {
                            otpCodeController.closeTimer();
                            otpCodeController.start.value = 60;
                            //verifyNumber();
                            otpCodeController.startTimer();
                          },
                          child: const TextWidget(text: 'Resend Code', color: rabbit,),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index){
                            return Padding(
                              padding: index == 6 ? const EdgeInsets.only(left: 0.0) : const EdgeInsets.only(left: 8.0),
                              child: Obx(() => _otpTextField(context, index == 0 ? true : false, otpCodeController.listController[index], otpCodeController.otpColor.value),),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Space(height: 10),
                  Obx(() => TextWidget(
                    text: 'Verification failed. Please try again',
                    color: otpCodeController.labelErrorColor.value,
                    size: 10,
                  )),
                  Expanded(
                    child: Container(
                      color: white,
                      width: 250,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 80,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                        ),
                        itemCount: 12,
                        itemBuilder: (BuildContext ctx, index) {
                          return index == 11 ? _buildDelete() :
                          _buildNumber(index + 1, index < 9 ?'${index + 1}' : index == 9 ? 'C' : '0');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
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
  Widget _otpTextField(BuildContext context, bool autoFocus, TextEditingController controller, Color color) {
    return  SizedBox(
      width: 30,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(3, 0, 0, 10),
            enabledBorder: UnderlineInputBorder(
              borderSide:  BorderSide(color: text),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: text),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: text),
            ),
          ),
          autofocus: autoFocus,
          readOnly: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 14, color: color),
          maxLines: 1,
          onChanged: (value) {
            if(value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
  Widget _buildNumber(int index, String number){
    return InkWell(
      onTap: () => otpCodeController.numberClick(index),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: text),
        ),
        child: Center(
          child: TextWidget(
            text: number,
            size: 16,
          ),
        ),
      ),
    );
  }
  Widget _buildDelete(){
    return InkWell(
      onTap: () => otpCodeController.deleteNumberClick(),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: text),
        ),
        child: const Center(
          child: IconWidget(
            icon: Icons.backspace_outlined,
            color: black,
            size: 24,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class BecomeDriverSuccessScreen extends StatelessWidget {
  const BecomeDriverSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      backgroundColor: white,
      appBar: null,
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLayout(1, Container()),
              _buildLayout(3, Container(
                width: size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: rabbit,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: IconWidget(
                          icon: Icons.check,
                          color: white,
                          size: 48,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const TextWidget(
                        isTitle: true,
                        text: 'Thank you',
                      ),
                    ),
                    const TextWidget(text: 'You are now submitted!',),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      width: 250,
                      child: const TextWidget(
                        textAlign: TextAlign.center,
                        text: 'You have successfully submitted a request to be our driver partner. you will be contacted your team very soon.',
                      ),
                    ),
                    ButtonWidget(
                        onPressed: () => Get.offAllNamed('/instruction'),
                        width: size.width - 100,
                        child: const TextWidget(
                          text: 'Got it',
                          color: white,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              )),
            ],
          ),
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
}
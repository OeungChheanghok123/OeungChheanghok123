import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class BecomeDriverFailScreen extends StatelessWidget {
  const BecomeDriverFailScreen({Key? key}) : super(key: key);

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
                        color: carrot,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: IconWidget(
                          icon: Icons.clear,
                          color: white,
                          size: 48,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const TextWidget(
                        isTitle: true,
                        text: 'Fail!',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      width: 260,
                      child: const TextWidget(
                        textAlign: TextAlign.center,
                        text: 'Your phone number is already to register!\nPlease try to login! Thanks.',
                      ),
                    ),
                    ButtonWidget(
                      onPressed: () => Get.offAllNamed('/log_in'),
                      width: size.width - 100,
                      color: carrot,
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

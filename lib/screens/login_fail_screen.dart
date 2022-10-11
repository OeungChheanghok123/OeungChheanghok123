import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class LoginFailScreen extends StatelessWidget {
  LoginFailScreen({Key? key}) : super(key: key);

  final getText = ''.obs;

  @override
  Widget build(BuildContext context) {
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
              _buildLayout(1, const SizedBox()),
              _buildLayout(3, _buildBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    getText.value = Get.arguments['message'];

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          _buildIconClose(),
          _buildTextFail(),
          _buildText(getText.value),
          _buildButton(context),
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
  Widget _buildIconClose() {
    return Container(
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
    );
  }
  Widget _buildTextFail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const TextWidget(
        isTitle: true,
        text: 'login Fail!',
      ),
    );
  }
  Widget _buildText(String txt) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      width: 260,
      child: TextWidget(
        textAlign: TextAlign.center,
        text: txt,
      ),
    );
  }
  Widget _buildButton(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ButtonWidget(
      onPressed: () => Get.offAllNamed('/log_in'),
      width: size.width - 100,
      color: carrot,
      child: const TextWidget(
        text: 'Got it',
        color: white,
        size: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

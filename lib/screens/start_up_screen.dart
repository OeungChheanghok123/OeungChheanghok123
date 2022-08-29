import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/languages_controller.dart';
import 'package:loy_eat/controllers/start_up_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/svg_picture_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final languagesController = Get.put(LanguagesController());
    final startUpController = Get.put(StartUpController());
    
    return Scaffold(
      extendBody: true,
      backgroundColor: rabbit,
      appBar: null,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: rabbit,
            child: SvgPictureWidget(
              key: key,
              imageString: 'assets/image/loy_eat_logo.svg',
              label: 'Loy Eat Logo',
              boxFit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 50,
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 3)),
              builder: (c, s) => s.connectionState == ConnectionState.done ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextWidget(
                    isTitle: true,
                    text: 'ជ្រើសរើសភាសា',
                    color: white,
                  ),
                  const Space(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: none,
                        onTap: () {
                          languagesController.changeLanguage('kh', 'KH');
                          //accountController.defaultLanguage(startUpController.khmerFlag);
                          startUpController.language = startUpController.khmerFlag;
                          Get.offAllNamed('/log_in');
                        },
                        child: _buildLanguage(startUpController.khmerFlag, 'ខ្មែរ', 'Cambodia Flag Logo',),
                      ),
                      const Space(width: 35),
                      InkWell(
                        splashColor: none,
                        onTap: () {
                          languagesController.changeLanguage('en', 'US');
                          //accountController.defaultLanguage(startUpController.englishFlag);
                          startUpController.language = startUpController.englishFlag;
                          Get.offAllNamed('/log_in');
                        },
                        child: _buildLanguage(startUpController.englishFlag, 'English', 'United kingdom Flag Logo',),
                      ),
                    ],
                  ),
                ],
              ) : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguage(String image, String text, String label){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 55,
          height: 35,
          child: SvgPictureWidget(
            imageString: image,
            label: label,
          ),
        ),
        const Space(),
        TextWidget(
          text: text,
          color: white,
        ),
      ],
    );
  }
}
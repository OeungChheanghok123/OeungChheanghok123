import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/languages_controller.dart';
import 'package:loy_eat/controllers/verify_phone_number_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class AccountController extends GetxController {
  var userProfile = 'assets/image/driver_profile.png'.obs;
  var driverName = 'Oeung Chheanghok'.obs;

  var defaultLanguage = ''.obs;
  final _changeLanguage = ''.obs;

  var khmerImage = 'assets/image/cambodia_flag.svg'.obs;
  var ukImage = 'assets/image/uk_flag.svg'.obs;
  var khmerLabel = 'ភាសាខ្មែរ'.obs;
  var ukLabel = 'English'.obs;

  var isSelectedKhmer = false.obs;
  var isSelectedEnglish = true.obs;
  var radioColorKhmer = white.obs;
  var radioColorEnglish = rabbit.obs;

  LanguagesController languagesController = Get.put(LanguagesController());
  VerifyPhoneNumberController verifyPhoneNumberController = Get.put(VerifyPhoneNumberController());

  @override
  void onInit() {
    super.onInit();
    defaultLanguage.value = _changeLanguage.value;
  }

  void selectItemLanguage(int index) {
    Get.back();
    Get.defaultDialog(
      radius: 5,
      title: '',
      titleStyle: const TextStyle(fontSize: 10),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(bottom: 5),
      middleTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      middleText: 'The app will be restarted.',
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: rabbit,
      cancelTextColor: text,
      buttonColor: none,
      onCancel: () => Get.back(),
      onConfirm: () {
        if (index == 1){
          isSelectedKhmer.value = true;
          isSelectedEnglish.value = false;
        } else {
          isSelectedEnglish.value = true;
          isSelectedKhmer.value = false;
        }
        if (isSelectedKhmer.value == true){
          radioColorKhmer.value = rabbit;
          radioColorEnglish.value = white;
          _changeLanguage.value = khmerImage.value;

          languagesController.changeLanguage('kh', 'KH');
        } else {
          radioColorKhmer.value = white;
          radioColorEnglish.value = rabbit;
          _changeLanguage.value = ukImage.value;

          languagesController.changeLanguage('en', 'US');
        }
        defaultLanguage.value = _changeLanguage.value;
        Get.offAllNamed('/instruction');
        Get.back();
      },
    );
  }
}
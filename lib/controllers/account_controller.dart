import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class AccountController extends GetxController {
  var userProfile = 'assets/image/driver_profile.png'.obs;
  var driverName = 'Oeung Chheanghok'.obs;
  var phoneNumber = '098 496 050'.obs;

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

  @override
  void onInit() {
    super.onInit();
    _changeLanguage.value = ukImage.value;
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
        } else {
          radioColorKhmer.value = white;
          radioColorEnglish.value = rabbit;
          _changeLanguage.value = ukImage.value;
        }

        defaultLanguage.value = _changeLanguage.value;
        Get.back();
      },
    );
  }
}
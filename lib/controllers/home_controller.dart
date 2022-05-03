import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/home_model.dart';
import 'package:loy_eat/models/notification_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class HomeController extends GetxController {
  var homeModel = HomeModel().obs;
  var notificationModel = listNotification;
  var toggleState = false.obs;
  var appBarColor = carrot.obs;
  var toggleIcon = Icons.toggle_off.obs;
  var status = "Offline".obs;
  var notificationColor = rabbit.obs;
  var notificationCount = 0.obs;
  var totalEarnings = 0.00.obs;
  var readAll = false.obs;

  @override
  void onInit() {
    super.onInit();
    totalEarnings.value = homeModel.value.deliveryFee + homeModel.value.bonus  + homeModel.value.tip;
    notificationCount.value = notificationModel.length;
  }

  void toggleClicked(){
    if (toggleState.value == false) {
      toggleState.value = true;
      appBarColor.value = rabbit;
      toggleIcon.value = Icons.toggle_on;
      status.value = "Online";
      notificationColor.value = carrot;
    }
    else if (toggleState.value == true) {
      toggleState.value = false;
      appBarColor.value = carrot;
      toggleIcon.value = Icons.toggle_off;
      status.value = "Offline";
      notificationColor.value = rabbit;
    }
  }

  void deleteNotification() {
    //notificationCount.value = 0;
    readAll.value = true;
  }
}
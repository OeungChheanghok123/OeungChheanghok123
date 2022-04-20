import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/report_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class ReportController extends GetxController{
  var scrollController = ScrollController();
  var reportModel = ReportModel().obs;
  var dateMonthReport = 'Dec 2021'.obs;
  var totalEarning = 0.00.obs;

  var isCanceled = false.obs;
  var isDelivered = true.obs;
  var colorTextCanceledStatus = black.obs;
  var colorRadioCanceledStatus = white.obs;
  var colorTextDeliveredStatus = rabbit.obs;
  var colorRadioDeliveredStatus = rabbit.obs;

  List<String> orderWeek = ['20 Dec - 26 Dec', '27 Dec - 2 Jan', '3 Jan - 9 Jan'];
  List<String> orderNo = ['211220', '211220', '211221', '211223', '211224', '211226'];

  @override
  void onInit() {
    super.onInit();
    totalEarning.value = reportModel.value.deliveryFee + reportModel.value.bonus + reportModel.value.tip;
  }
  void radioButtonBar(int index) {
    if (index == 1){
      isCanceled.value = true;
      isDelivered.value = false;
    } else {
      isCanceled.value = false;
      isDelivered.value = true;
    }

    if (isCanceled.value == true){
      colorTextCanceledStatus.value = rabbit;
      colorRadioCanceledStatus.value = rabbit;
      colorTextDeliveredStatus.value = black;
      colorRadioDeliveredStatus.value = white;
    } else {
      colorTextCanceledStatus.value = black;
      colorRadioCanceledStatus.value = white;
      colorTextDeliveredStatus.value = rabbit;
      colorRadioDeliveredStatus.value = rabbit;
    }
  }
}
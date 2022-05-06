import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/models/report_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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


  final List<ReportChart> data = [
    ReportChart(date: '15\nMon', price: 12.45, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '16\nTue', price: 30.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '17\nWed', price: 15.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '18\nThu', price: 30.05, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '19\nFri', price: 40.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '20\nSat', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '21\nSun', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
  ];

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
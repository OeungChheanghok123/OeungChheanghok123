import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/home_model.dart';
import 'package:loy_eat/models/notification_model.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class HomeController extends GetxController {
  var homeModel = HomeModel().obs;
  var notificationModel = listNotification;
  var notificationIndex = 100.obs;
  var toggleState = false.obs;
  var appBarColor = carrot.obs;
  var toggleIcon = Icons.toggle_off.obs;
  var status = "Offline".obs;
  var notificationColor = rabbit.obs;
  var notificationCount = 0.obs;
  var totalEarnings = 0.00.obs;
  var readAll = false.obs;
  var startDate  = 'Start Date'.obs;
  var endDate = 'End Date'.obs;

  final List<ReportChart> data = [
    ReportChart(date: '15\nMon', price: 12.45, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '16\nTue', price: 30.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '17\nWed', price: 15.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '18\nThu', price: 30.05, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '19\nFri', price: 41.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '20\nSat', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '21\nSun', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
  ];


  @override
  void onInit() {
    super.onInit();
    totalEarnings.value = homeModel.value.deliveryFee + homeModel.value.bonus  + homeModel.value.tip;
    notificationCount.value = listNotification.length;
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
  void readAllNotification() {
    readAll.value = true;
  }
  Future<Widget> wait3SecAndLoadData() async {
    await Future.delayed(const Duration(seconds: 3));
    return Container();
  }
}
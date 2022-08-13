import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/notification_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:loy_eat/widgets/layout_widget/color.dart';

class HomeController extends GetxController{
  var notificationModel = listNotification;
  var notificationIndex = 100.obs;
  var toggleState = false.obs;
  var appBarColor = carrot.obs;
  var toggleIcon = Icons.toggle_off.obs;
  var status = "Offline".obs;
  var notificationColor = rabbit.obs;
  var notificationCount = 0.obs;
  var readAll = false.obs;
  var startDate  = 'Start Date'.obs;
  var endDate = 'End Date'.obs;

  Future<Widget> wait3SecAndLoadData() async {
    await Future.delayed(const Duration(seconds: 3));
    return Container();
  }

  final List<ReportChart> chartData = [
    ReportChart(date: '15\nMon', price: 12.45, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '16\nTue', price: 30.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '17\nWed', price: 15.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '18\nThu', price: 30.05, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '19\nFri', price: 41.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '20\nSat', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '21\nSun', price: 0, barColor: charts.ColorUtil.fromDartColor(rabbit)),
  ];

  final _driverReportData = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverReportModel>> get data => _driverReportData.value;

  @override
  void onInit() {
    CollectionReference notification = FirebaseFirestore.instance.collection('notification');
    notification.where('isRead', isEqualTo: false).get().then((QuerySnapshot snapshot) => {
      notificationCount.value = snapshot.docs.length,
    });
    _loadDriverReportData();
    super.onInit();
  }
  void _loadDriverReportData() {
    try {
      final data = FirebaseFirestore.instance.collection(DriverReportModel.collectionName).snapshots();
      data.listen((result) {
        final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();
        _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.success, data: driverReport);
      });
    } catch (ex) {
      _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.error, data: null);
    }
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
}
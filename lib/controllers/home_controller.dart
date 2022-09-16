import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:loy_eat/widgets/layout_widget/color.dart';

class HomeController extends GetxController{
  var toggleState = false.obs;
  var status = "Offline".obs;
  var appBarColor = carrot.obs;
  var toggleIcon = Icons.toggle_off.obs;

  var notificationColor = rabbit.obs;
  var notificationCount = 0.obs;
  var readAll = false.obs;

  var startDate  = 'Start Date'.obs;
  var endDate = 'End Date'.obs;

  var id = '';
  var driverDocId = '';
  var driverReportDocId = '';

  Timer? timer;
  var onlineHour = 0.obs;
  var onlineMinute = 0.obs;
  var onlineSecond = 0.obs;

  final driverReportCollection = FirebaseFirestore.instance.collection(DriverReportModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);

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

  final mainPageController = Get.put(MainPageController());

  @override
  void onInit() {
    loadNotification();
    _loadDriverReportData();
    super.onInit();
  }

  void _loadDriverReportData() {
    try {
      final driverPhoneNumber = mainPageController.readDriverPhoneNumber();
      final driver = driverCollection.where(DriverModel.telString, isEqualTo: driverPhoneNumber).snapshots();
      driver.listen((e) {
        final driverData = e.docs.map((e) => DriverModel.fromMap(e.data())).toList();

        id = driverData[0].driverId;
        toggleState.value = driverData[0].isOnline;

        loadDriverDocumentId(id);
        loadDriverReportDocumentId(id);
        loadDriverReport(id);
        loadToggleState();
      });
    } catch (ex) {
      _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void loadDriverReport(String id) {
    final data = driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).snapshots();
    data.listen((result) {
      final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();
      _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.success, data: driverReport);

      onlineHour.value = int.parse(driverReport[0].onlineHour);
      onlineMinute.value = int.parse(driverReport[0].onlineMinute);
    });
  }

  void loadToggleState(){
    if (toggleState.value == true) {
      appBarColor.value = rabbit;
      toggleIcon.value = Icons.toggle_on;
      status.value = "Online";
      notificationColor.value = carrot;
    }
    else {
      appBarColor.value = carrot;
      toggleIcon.value = Icons.toggle_off;
      status.value = "Offline";
      notificationColor.value = rabbit;
    }
  }

  void loadDriverDocumentId(String id) {
    driverCollection.where(DriverModel.driverIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) { // ignore: avoid_function_literals_in_foreach_calls
        driverDocId = element.id;
      }),
    });
  }
  void loadDriverReportDocumentId(String id) {
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) { // ignore: avoid_function_literals_in_foreach_calls
        driverReportDocId = element.id;
      }),
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateOnlineTimer());
  }
  void closeTimer() {
    timer?.cancel();
  }
  void updateOnlineTimer() {
    const addSeconds = 1;
    onlineSecond.value = onlineSecond.value + addSeconds;

    if (onlineSecond.value == 60) {
      if (onlineSecond.value == 60 && onlineMinute.value == 59) {
        onlineMinute.value = 60;
        driverReportCollection.doc(driverReportDocId).update({
          DriverReportModel.onlineMinuteString: '0',
        }).then((_) => debugPrint('minute timer updated'));
        onlineSecond.value = 0;
      }
      else {
        onlineMinute.value = onlineMinute.value + 1;
        driverReportCollection.doc(driverReportDocId).update({
          DriverReportModel.onlineMinuteString: onlineMinute.toString(),
        }).then((_) => debugPrint('minute timer updated'));
        onlineSecond.value = 0;
      }

      if (onlineMinute.value == 60) {
        onlineHour.value = onlineHour.value + 1;
        onlineMinute.value = 0;
        onlineSecond.value = 0;
        driverReportCollection.doc(driverReportDocId).update({
          DriverReportModel.onlineHourString: onlineHour.toString(),
          DriverReportModel.onlineMinuteString: onlineMinute.toString(),
        }).then((_) => debugPrint('hour timer updated'));
      }
    }
  }

  void loadNotification() {
    final notification = FirebaseFirestore.instance.collection('notification');
    final data = notification.where('isRead', isEqualTo: false).snapshots();
    data.listen((e) {
      notificationCount.value = e.docs.length;
    });
  }

  void toggleClicked() {
    if (toggleState.value == false) {
      driverCollection.doc(driverDocId).update({DriverModel.isOnlineString : true}).then((_) => debugPrint('Driver is Online'));
      startTimer();
    }
    else {
      driverCollection.doc(driverDocId).update({DriverModel.isOnlineString : false}).then((_) => debugPrint('Driver is Offline'));
      closeTimer();
    }
    loadToggleState();
  }

  Future<Widget> wait3SecAndLoadData() async {
    await Future.delayed(const Duration(seconds: 3));
    return Container();
  }
}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class HomeController extends GetxController{
  var toggleState = false.obs;
  var status = "Offline".obs;
  var appBarColor = carrot.obs;
  var toggleIcon = Icons.toggle_off.obs;

  var notificationColor = rabbit.obs;
  var notificationCount = 0.obs;
  var readAll = false.obs;

  var isOnline = false.obs;
  var isSearch = false.obs;
  var startDate  = 'Start Date'.obs;
  var endDate = 'End Date'.obs;
  var dayStart = 0;
  var monthStart = 0;
  var yearStart = 0;
  var dayEnd = 0;
  var monthEnd = 0;
  var yearEnd = 0;

  List<ReportChart> chartData = [];

  var id = '';
  var driverPhoneNumber = ''.obs;
  var driverDocId = '';
  var driverReportDocId = '';

  Timer? timer;
  var onlineHour = 0.obs;
  var onlineMinute = 0.obs;
  var onlineSecond = 0.obs;

  var driverReportLength = 0.obs;

  var date = ''.obs;
  var totalOnlineHour = 0.obs;
  var totalOnlineMinute = 0.obs;
  var totalDistance = 0.0.obs;
  var totalPoint = 0.obs;
  var totalTrip = 0.obs;
  var totalCustomerRate = 0.0.obs;
  var totalMerchantRate = 0.0.obs;

  var totalDeliveryFee = 0.0.obs;
  var totalBonus = 0.0.obs;
  var totalTip = 0.0.obs;
  var totalEarning = 0.0.obs;

  var outputDate = '';
  var outputDay = '';
  var outputMonth = '';
  var outputYear = '';

  final driverReportCollection = FirebaseFirestore.instance.collection(DriverReportModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);

  final _driverReportData = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverReportModel>> get data => _driverReportData.value;

  @override
  void onInit() {
    startDate.value  = 'Start Date';
    endDate.value = 'End Date';

    loadNotification();
    loadDriverReportData();
    super.onInit();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    debugPrint('user :${user?.phoneNumber.toString()}');
    final num = user?.phoneNumber.toString();
    final list = num?.split('').toList();
    debugPrint('list :$list');
    list?.removeAt(0);
    list?.removeAt(0);
    list?.removeAt(0);
    list?.removeAt(0);
    var phoneNumber = list?.join('');
    debugPrint('phoneNumber in main : ${phoneNumber.toString()}');
    driverPhoneNumber.value = phoneNumber.toString();
  }

  void loadDriverReportData() {
    try {
      getCurrentUser();
      final driver = driverCollection.where(DriverModel.telString, isEqualTo: driverPhoneNumber.value).snapshots();
      driver.listen((e) {
        if (e.docs.isNotEmpty) {
          final driverData = e.docs.map((e) => DriverModel.fromMap(e.data())).toList();

          id = driverData[0].driverId;
          toggleState.value = driverData[0].isOnline;

          loadDriverDocumentId(id);
          loadDriverReportDocumentId();
          loadDriverReport(id);
          loadToggleState();
        }
      });
    } catch (ex) {
      _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void loadDriverReport(String id) {
    if (startDate.value == 'Start Date' && endDate.value == 'End Date') {
      final data = driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).limit(7).orderBy(DriverReportModel.dayString, descending: true).snapshots();
      data.listen((result) {
        final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();
        driverReportLength.value = driverReport.length;
        clearData();
        dataBase(driverReport);
        _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.success, data: driverReport);
      });
    }
    else {
      final data = driverReportCollection
          .where(DriverReportModel.driverIdString, isEqualTo: id)
          .where(DriverReportModel.monthString, isEqualTo: monthStart)
          .where(DriverReportModel.dayString, isLessThanOrEqualTo: dayEnd, isGreaterThanOrEqualTo: dayStart).limit(7)
          .snapshots();
      data.listen((result) {
        if (result.docs.isEmpty) {
          debugPrint('No Data Show');
          final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();
          driverReportLength.value = driverReport.length;
          clearData();
          final reverseReport = driverReport.reversed;
          dataBase(reverseReport.toList());
        } else {
          debugPrint('Data is not empty');
          final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();
          driverReportLength.value = driverReport.length;
          clearData();
          final reverseReport = driverReport.reversed;
          dataBase(reverseReport.toList());
          _driverReportData.value = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.success, data: driverReport);
        }
      });
    }
  }
  void dataBase(List<DriverReportModel> driverReport) {
    for(int i = 0 ; i < driverReport.length ; i++) {
      final hour = driverReport[i].onlineHour;
      final minute = driverReport[i].onlineMinute;
      final point = driverReport[i].point;
      final distance = driverReport[i].distance;
      final trip = driverReport[i].trip;
      final customerRate = driverReport[i].customerRating;
      final merchantRate = driverReport[i].merchantRating;

      final fee = driverReport[i].deliveryFee;
      final bonus = driverReport[i].bonus;
      final tip = driverReport[i].tip;

      totalOnlineHour.value = totalOnlineHour.value + int.parse(hour);
      totalOnlineMinute.value = totalOnlineMinute.value + int.parse(minute);
      totalPoint.value = totalPoint.value + int.parse(point);
      totalDistance.value = totalDistance.value + double.parse(distance);
      totalTrip.value = totalTrip.value + int.parse(trip);
      totalCustomerRate.value = totalCustomerRate.value + double.parse(customerRate);
      totalMerchantRate.value = totalMerchantRate.value + double.parse(merchantRate);

      totalDeliveryFee.value = totalDeliveryFee.value + double.parse(fee);
      totalBonus.value = totalBonus.value + double.parse(bonus);
      totalTip.value = totalTip.value + double.parse(tip);

      if (totalOnlineMinute.value >= 60) {
        totalOnlineMinute.value = totalOnlineMinute.value - 60;
        totalOnlineHour.value = totalOnlineHour.value + 1;
      }

      onlineHour.value = int.parse(driverReport[i].onlineHour);
      onlineMinute.value = int.parse(driverReport[i].onlineMinute);
      totalEarning.value = double.parse(driverReport[i].deliveryFee) + double.parse(driverReport[i].tip) + double.parse(driverReport[i].bonus);
      date.value = driverReport[i].date;

      DateTime parseDate = DateFormat('dd-MMM-yy').parse(date.value);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd-MMM');
      var outputDate = outputFormat.format(inputDate);
      var finalDate = outputDate.replaceAll('-', '\n');

      chartData.add(ReportChart(id: i, date: finalDate, price: totalEarning.value));
    }

  }
  void clearData() {
    totalOnlineHour.value = 0;
    totalOnlineMinute.value = 0;
    totalPoint.value = 0;
    totalDistance.value = 0.0;
    totalTrip.value = 0 ;
    totalCustomerRate.value = 0.0;
    totalMerchantRate.value = 0.0;

    totalDeliveryFee.value = 0.0;
    totalBonus.value = 0.0;
    totalTip.value = 0.0;

    chartData.clear();
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
      snapshot.docs.forEach((element) {     // ignore: avoid_function_literals_in_foreach_calls
        driverDocId = element.id;
      }),
    });
  }
  void loadDriverReportDocumentId() {
    var today = DateTime.now();
    var format = DateFormat('dd-MMM-yy');
    var output = format.format(today);
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).where(DriverReportModel.dateString, isEqualTo: output).get().then((snapshot) => {
      snapshot.docs.forEach((element) {    // ignore: avoid_function_literals_in_foreach_calls
        driverReportDocId = element.id;
        var minute = element['online_minute'];
        onlineMinute.value = int.parse(minute);
        debugPrint('online minute : ${onlineMinute.value}');
      }),
    });
  }

  void startTimer() {
    debugPrint('timer is start');
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateOnlineTimer());
  }
  void closeTimer() {
    debugPrint('timer is close');
    timer?.cancel();
  }
  void updateOnlineTimer() {

    const addSeconds = 1;
    onlineSecond.value = onlineSecond.value + addSeconds;

    if (onlineSecond.value == 60) {
      loadDriverReportDocumentId();
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

  toggleClicked() async {
    debugPrint('driverDoc = $driverDocId');
    if (toggleState.value == false) {
      debugPrint('Driver is Online');
      isOnline.value = true;
      toggleState.value = true;
      loadToggleState();

      var today = DateTime.now();
      var format = DateFormat('dd-MMM-yy');
      var day = DateFormat('d');
      var month = DateFormat('M');
      var year = DateFormat('yy');

      outputDate = format.format(today);
      outputDay = day.format(today);
      outputMonth = month.format(today);
      outputYear = year.format(today);

      await driverCollection.doc(driverDocId).update({DriverModel.isOnlineString : true});
      loadDriverReportCollection();
    }
    else {
      debugPrint('Driver is Offline');
      isOnline.value = false;
      toggleState.value = false;
      loadToggleState();

      await driverCollection.doc(driverDocId).update({DriverModel.isOnlineString : false});
    }
  }

  loadDriverReportCollection() {
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).where(DriverReportModel.dateString, isEqualTo: outputDate).get().then((value) {
      if (value.docs.isEmpty) {
        driverReportCollection.add({
          DriverReportModel.driverIdString: id,
          DriverReportModel.dateString: outputDate,
          DriverReportModel.dayString: int.parse(outputDay),
          DriverReportModel.monthString: int.parse(outputMonth),
          DriverReportModel.yearString: int.parse(outputYear),
          DriverReportModel.customerRatingString: '5.0',
          DriverReportModel.merchantRatingString: '5.0',
          DriverReportModel.bonusString: '0.00',
          DriverReportModel.deliveryFeeString: '0.00',
          DriverReportModel.distanceString: '0.00',
          DriverReportModel.onlineHourString: '0',
          DriverReportModel.onlineMinuteString: '0',
          DriverReportModel.pointString: '0',
          DriverReportModel.tipString: '0.0',
          DriverReportModel.tripString: '0',
        }).then((_) {
          debugPrint('driver report was write driver id: $id');
          loadDriverReportDocumentId();
          startTimer();
        });
      }
      else {
        loadDriverReportDocumentId();
        startTimer();
      }
    });

  }

  Future<Widget> wait3SecAndLoadData() async {
    await Future.delayed(const Duration(seconds: 3));
    return Container();
  }
}
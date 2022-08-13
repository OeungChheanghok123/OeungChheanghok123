import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/models/report_chart.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportController extends GetxController{
  var scrollController = ScrollController();
  var dateMonthReport = 'Nov-2021'.obs;
  var isCanceled = false.obs;
  var isDelivered = true.obs;
  var colorTextCanceledStatus = black.obs;
  var colorRadioCanceledStatus = white.obs;
  var colorTextDeliveredStatus = rabbit.obs;
  var colorRadioDeliveredStatus = rabbit.obs;
  var dataDatePicker = ''.obs;

  final List<ReportChart> chartData = [
    ReportChart(date: '1-7', price: 12.45, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '8-13', price: 30.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '14-20', price: 15.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '21-27', price: 30.05, barColor: charts.ColorUtil.fromDartColor(rabbit)),
    ReportChart(date: '28-31', price: 40.00, barColor: charts.ColorUtil.fromDartColor(rabbit)),
  ];

  final _driverReportData = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverReportModel>> get driverReportData => _driverReportData.value;

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _deliverData = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DeliverModel>> get deliverData => _deliverData.value;

  @override
  void onInit() {
    _loadDriverReportData();
    _loadOrderData();
    _loadDeliverData();
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
  void _loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).orderBy(OrderModel.dateString, descending: true).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadDeliverData() {
    try {
      final data = FirebaseFirestore.instance.collection(DeliverModel.collectionName).orderBy(DeliverModel.dateString, descending: true).snapshots();
      data.listen((result) {
        final delivers = result.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
        _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.success, data: delivers);
      });
    } catch (ex) {
      _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.error, data: null);
    }
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
      colorTextCanceledStatus.value = carrot;
      colorRadioCanceledStatus.value = carrot;
      colorTextDeliveredStatus.value = black;
      colorRadioDeliveredStatus.value = white;
    } else {
      colorTextCanceledStatus.value = black;
      colorRadioCanceledStatus.value = white;
      colorTextDeliveredStatus.value = rabbit;
      colorRadioDeliveredStatus.value = rabbit;
    }
  }
  void calenderFunction(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((DateTime? value) {
      if (value != null) {
        DateTime _fromDate = DateTime.now();
        _fromDate = value;
        var outputFormat = DateFormat('dd-MMMM-yyyy');
        final String date = outputFormat.format(_fromDate);
        dataDatePicker.value = date;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected date: $date')),
        );
      }
    });
  }
  void cardOrder(String orderId) {
    Get.toNamed('/report_order_detail', arguments: {'order': orderId});
  }
}
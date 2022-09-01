import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class ReportController extends GetxController{
  var dataDatePicker = ''.obs;
  var isHasData = true.obs;

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _deliverData = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DeliverModel>> get deliverData => _deliverData.value;

  @override
  void onInit() {
    super.onInit();
    _loadOrderData();
    _loadDeliverData();
  }
  void _loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).orderBy(OrderModel.orderIdString, descending: true).snapshots();
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
      final data = FirebaseFirestore.instance.collection(DeliverModel.collectionName).orderBy(DeliverModel.orderIdString, descending: true).snapshots();
      data.listen((result) {
        final delivers = result.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
        _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.success, data: delivers);
      });
    } catch (ex) {
      _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadOrderByDate(String date) {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).where(OrderModel.dateString, isEqualTo: date).orderBy(OrderModel.orderIdString, descending: true).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        if (orders.isNotEmpty) {
          isHasData.value = true;
          _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);
        } else {
          isHasData.value = false;
        }
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }

  void showCalender(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((DateTime? value) {
      if (value != null) {
        DateTime _fromDate = DateTime.now();
        _fromDate = value;
        var outputFormat = DateFormat('dd-MMM-yy');
        final String date = outputFormat.format(_fromDate);
        dataDatePicker.value = date;
        _loadOrderByDate(dataDatePicker.value);
      }
    });
  }
  void deleteFilter() {
    _loadOrderData();
    isHasData.value = true;
    dataDatePicker.value = '';
  }
  void cardOrderPage(String orderId) {
    Get.toNamed('/report_order_detail', arguments: {'order': orderId});
  }
}
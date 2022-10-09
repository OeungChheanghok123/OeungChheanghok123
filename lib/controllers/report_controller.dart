import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class ReportController extends GetxController{
  var id = ''.obs;
  var dataDatePicker = ''.obs;
  var isHasData = true.obs;

  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _deliverData = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DeliverModel>> get deliverData => _deliverData.value;

  final mainPageController = Get.put(MainPageController());

  @override
  void onInit() {
    super.onInit();
    _loadDriverId();
  }
  void _loadDriverId() {
    var num = mainPageController.readDriverPhoneNumber();
    debugPrint('phone number on report controller : $num');
    final data = driverCollection.where(DriverModel.telString, isEqualTo: num).snapshots();
    data.listen((result) {
      final driver = result.docs.map((e) => DriverModel.fromMap(e.data())).toList();
      id.value = driver[0].driverId;
      _loadOrderData(id.value);
      _loadDeliverData(id.value);
    });
  }
  void _loadOrderData(String id) {
    try {
      final data = orderCollection.where(OrderModel.driverIdString, isEqualTo: id).orderBy(OrderModel.orderIdString, descending: true).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadDeliverData(String id) {
    try {
      final data = deliverCollection.where(DeliverModel.driverIdString, isEqualTo: id).orderBy(DeliverModel.orderIdString, descending: true).snapshots();
      data.listen((result) {
        final delivers = result.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
        _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.success, data: delivers);
      });
    } catch (ex) {
      _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadOrderByDate(String id, String date) {
    try {
      final data = orderCollection.orderBy(OrderModel.orderIdString, descending: true)
          .where(OrderModel.driverIdString, isEqualTo: id)
          .where(OrderModel.dateString, isEqualTo: date)
          .snapshots();
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
        _loadOrderByDate(id.value, dataDatePicker.value);
      }
    });
  }
  void deleteFilter() {
    _loadOrderData(id.value);
    isHasData.value = true;
    dataDatePicker.value = '';
  }
  void cardOrderPage(String orderId, String deliveryFee, String tip, String bonus, String customerName) {
    Get.toNamed('/report_order_detail', arguments: {'order': orderId, 'delivery_fee': deliveryFee, 'tip': tip, 'bonus': bonus, 'customerName': customerName});
  }
}
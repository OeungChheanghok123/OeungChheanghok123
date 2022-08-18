import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class OrderController extends GetxController{
  var isNewOrder = false.obs;
  var orderId = ''.obs;

  var orderEmpty = "Sorry, No order yet!";
  var orderCancelByCustomer = "You won't be paid for this delivery, but we will try to find another trip.";
  var reasonCustomerCancel = "Sorry! Order #123456 for Sovongdy has been canceled due to ...";
  var reasonMerchantCancel = "Sorry! Order #123456 has been canceled by Cafe Amazon (PPIU) due to ...";

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  @override
  void onInit() {
    _loadOrderData();
    super.onInit();
  }
  void _loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).where(OrderModel.isNewString, isEqualTo: true).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        final newOrder = orders;
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: newOrder);
        if(orders.isNotEmpty){
          isNewOrder.value = true;
          orderId.value = orders[0].orderId;
        } else {
          isNewOrder.value = false;
          orderId.value = '';
        }
        debugPrint('order ID : ${orderId.value}');
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}
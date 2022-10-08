import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class ReportOrderDetailController extends GetxController{

  final remarkController = TextEditingController();
  var getOrderNo = ''.obs;
  var customerNo = ''.obs;
  var merchantNo = ''.obs;
  var itemOrder = [].obs;
  var itemLength = 0.obs;
  var totalMoney = 0.0.obs;

  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);
  final customerCollection = FirebaseFirestore.instance.collection(CustomerModel.collectionName);
  final merchantCollection = FirebaseFirestore.instance.collection(MerchantModel.collectionName);

  final _customerData = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<CustomerModel>> get customerData => _customerData.value;

  final _merchantData = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<MerchantModel>> get merchantData => _merchantData.value;


  @override
  void onInit() {
    super.onInit();
    getOrderNo.value = Get.arguments['order'];
    loadOrderData();
    loadDeliverData();
  }

  void loadOrderData() {
    final order = orderCollection.where(OrderModel.orderIdString, isEqualTo: getOrderNo.value).snapshots();
    order.listen((e) {
      final data = e.docs.map((e) => OrderModel.fromMap(e.data())).toList();
      customerNo.value = data[0].customerId;
      getCustomerDetail(customerNo.value);
      merchantNo.value = data[0].merchantId;
      getMerchantDetail(merchantNo.value);
    });
  }
  void loadDeliverData() {
    final deliver = deliverCollection.where(DeliverModel.orderIdString, isEqualTo: getOrderNo.value).snapshots();
    deliver.listen((e) {
      final data = e.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
      itemOrder.add(data[0].items);
      itemLength.value = data[0].items.length;
      totalMoney.value = double.parse(data[0].deliveryFee);
    });
  }

  void getCustomerDetail(String id) {
    try {
      final data = customerCollection.where(CustomerModel.customerIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final customer = result.docs.map((e) => CustomerModel.fromMap(e.data())).toList();
        _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.success, data: customer);
      });
    } catch (ex) {
      _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void getMerchantDetail(String id) {
    try {
      final data = merchantCollection.where(MerchantModel.merchantIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final merchant = result.docs.map((e) => MerchantModel.fromMap(e.data())).toList();
        _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.success, data: merchant);
      });
    } catch (ex) {
      _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}
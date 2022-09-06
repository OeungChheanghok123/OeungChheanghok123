import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class NewOrderCardController extends GetxController {
  final orderController = Get.put(OrderController());
  late Timer _timer;
  var startCounter = 60.obs;
  var newOrderId = ''.obs;
  var merchantId = ''.obs;
  var merchantName = ''.obs;
  var customerId = ''.obs;
  var customerName = ''.obs;
  var orderDocId = '';
  var deliverDocId = '';

  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _merchantData = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<MerchantModel>> get merchantData => _merchantData.value;

  final _customerData = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<CustomerModel>> get customerData => _customerData.value;

  final _deliverData = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DeliverModel>> get deliverData => _deliverData.value;

  @override
  void onInit() {
    _loadOrderData();
    startTimer();
    super.onInit();
  }
  @override
  void onClose() {
    closeTimer();
    super.onClose();
  }

  void getDocumentId() {
    orderCollection.where(DeliverModel.orderIdString, isEqualTo: newOrderId.value).get().then((snapshot) => {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((element) {
        orderDocId = element.id;
      }),
    });
    deliverCollection.where(DeliverModel.orderIdString, isEqualTo: newOrderId.value).get().then((snapshot) => {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((element) {
        deliverDocId = element.id;
      }),
    });
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
        if (startCounter.value == 0) {
          closeTimer();
          Get.defaultDialog(
            radius: 5,
            title: '',
            barrierDismissible: false,
            titleStyle: const TextStyle(fontSize: 10),
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(15),
            middleTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            middleText: 'The time is out, the delivery will auto to reject.',
            textConfirm: 'Confirm',
            confirmTextColor: white,
            buttonColor: rabbit,
            onConfirm: (){
              orderController.isNewOrder.value = false;
              orderCollection.doc(orderDocId).update({OrderModel.isNewString : false}).then((_) => debugPrint('update successful.'));
              deliverCollection.doc(deliverDocId).update({DeliverModel.processString : 'Rejected'}).then((_) => debugPrint('order id $newOrderId was reject.'));
              Get.offNamed('/instruction');
              Get.back();
            },
          );
        } else {
          startCounter--;
        }
      },
    );
  }
  void closeTimer() {
    _timer.cancel();
  }
  void showDialogReject() {
    Get.defaultDialog(
      radius: 5,
      title: '',
      titleStyle: const TextStyle(fontSize: 10),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(15),
      middleTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      middleText: 'Are you sure to reject this delivery?',
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: white,
      cancelTextColor: rabbit,
      buttonColor: rabbit,
      onConfirm: (){
        orderController.isNewOrder.value = false;
        orderCollection.doc(orderDocId).update({OrderModel.isNewString : false}).then((_) => debugPrint('update successful.'));
        deliverCollection.doc(deliverDocId).update({DeliverModel.processString : 'Rejected'}).then((_) => debugPrint('order id $newOrderId was reject.'));
        closeTimer();
        Get.back();
        Get.toNamed('/instruction');
      },
      onCancel:(){
        Get.back();
      },
    );
  }

  void _loadOrderData() {
    try {
      final data = FirebaseFirestore.instance.collection(OrderModel.collectionName).where(OrderModel.orderIdString, isEqualTo: orderController.orderId.value).snapshots();
      data.listen((result) {
        final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        newOrderId.value = orders[0].orderId;
        merchantId.value = orders[0].merchantId;
        merchantName.value = orders[0].merchantName;
        customerId.value = orders[0].customerId;
        customerName.value = orders[0].customerName;
        _loadMerchantData(merchantId.value);
        _loadCustomerData(customerId.value);
        _loadDeliverData(newOrderId.value);
        getDocumentId();
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: orders);
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadMerchantData(String id) {
    try {
      final data = FirebaseFirestore.instance.collection(MerchantModel.collectionName).where(MerchantModel.merchantIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final merchant = result.docs.map((e) => MerchantModel.fromMap(e.data())).toList();
        _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.success, data: merchant);
      });
    } catch (ex) {
      _merchantData.value = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadCustomerData(String id) {
    try {
      final data = FirebaseFirestore.instance.collection(CustomerModel.collectionName).where(CustomerModel.customerIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final customer = result.docs.map((e) => CustomerModel.fromMap(e.data())).toList();
        _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.success, data: customer);
      });
    } catch (ex) {
      _customerData.value = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadDeliverData(String id) {
    try {
      final data = FirebaseFirestore.instance.collection(DeliverModel.collectionName).where(DeliverModel.orderIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final deliver = result.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
        _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.success, data: deliver);
      });
    } catch (ex) {
      _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}
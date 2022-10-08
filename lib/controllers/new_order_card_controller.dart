import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/customer_model.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/merchant_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class NewOrderCardController extends GetxController {
  late Timer _timer;
  var startCounter = 60.obs;

  final mainPageController = Get.put(MainPageController());

  final driverReportCollection = FirebaseFirestore.instance.collection(DriverReportModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);
  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);
  final merchantCollection = FirebaseFirestore.instance.collection(MerchantModel.collectionName);
  final customerCollection = FirebaseFirestore.instance.collection(CustomerModel.collectionName);

  final _orderData = RemoteData<List<OrderModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<OrderModel>> get orderData => _orderData.value;

  final _merchantData = RemoteData<List<MerchantModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<MerchantModel>> get merchantData => _merchantData.value;

  final _customerData = RemoteData<List<CustomerModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<CustomerModel>> get customerData => _customerData.value;

  final _deliverData = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DeliverModel>> get deliverData => _deliverData.value;

  var newOrderId = ''.obs;
  var orderId = ''.obs;
  var orderDate = ''.obs;
  var merchantId = ''.obs;
  var customerId = ''.obs;
  var customerName = ''.obs;

  var driverReportDocId = ''.obs;
  var orderDocId = ''.obs;
  var deliverDocId = ''.obs;

  @override
  void onInit() {
    startTimer();
    _loadNewOrder();
    super.onInit();
  }
  @override
  void onClose() {
    super.onClose();
    closeTimer();
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
            middleTextStyle: const TextStyle(fontSize: 14),
            middleText: 'The time is out, the delivery will auto to reject.',
            textConfirm: 'Confirm',
            confirmTextColor: white,
            buttonColor: rabbit,
            onConfirm: () => rejectFunction(),
          );
        }
        else {
          startCounter--;
        }
      },
    );
  }
  void closeTimer() {
    _timer.cancel();
    startCounter.value = 60;
  }
  void showDialogReject() {
    Get.defaultDialog(
      radius: 5,
      title: '',
      titleStyle: const TextStyle(fontSize: 10),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(15),
      middleTextStyle: const TextStyle(fontSize: 14),
      middleText: 'Are you sure to reject this delivery?',
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: white,
      cancelTextColor: rabbit,
      buttonColor: rabbit,
      onConfirm: () => rejectFunction(),
      onCancel:() => Get.back(),
    );
  }

  void _loadNewOrder() {
    final data = orderCollection.where(OrderModel.isNewString, isEqualTo: true).snapshots();
    data.listen((result) {
      final orders = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();

      if (orders.isNotEmpty) {
        startTimer();

        newOrderId.value = '';
        newOrderId.value = orders[0].orderId;
        orderId.value = newOrderId.value;
        orderDate.value = orders[0].date;
        _loadOrderData(newOrderId.value);
        _loadDeliverData(newOrderId.value);
        _getDocumentId(newOrderId.value);

        merchantId.value = '';
        merchantId.value = orders[0].merchantId;
        _loadMerchantData(merchantId.value);

        customerId.value = '';
        customerId.value = orders[0].customerId;
        customerName.value = orders[0].customerName;
        _loadCustomerData(customerId.value);
      }
      else {
        closeTimer();

        newOrderId.value = '';
        merchantId.value = '';
        customerId.value = '';
      }
    });
  }
  void _loadOrderData(String id) {
    try {
      final data = orderCollection.where(OrderModel.orderIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final order = result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.success, data: order);
      });
    } catch (ex) {
      _orderData.value = RemoteData<List<OrderModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void _loadMerchantData(String id) {
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
  void _loadCustomerData(String id) {
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
  void _loadDeliverData(String id) {
    try {
      final data = deliverCollection.where(DeliverModel.orderIdString, isEqualTo: id).snapshots();
      data.listen((result) {
        final deliver = result.docs.map((e) => DeliverModel.fromMap(e.data())).toList();
        _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.success, data: deliver);
      });
    } catch (ex) {
      _deliverData.value = RemoteData<List<DeliverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }

  void _getDocumentId(String id) {
    orderCollection.where(DeliverModel.orderIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {       // ignore: avoid_function_literals_in_foreach_calls
        orderDocId.value = '';
        orderDocId.value = element.id;
        debugPrint('orderDocId : ${orderDocId.value}');
      }),
    });
    deliverCollection.where(DeliverModel.orderIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {       // ignore: avoid_function_literals_in_foreach_calls
        deliverDocId.value = '';
        deliverDocId.value = element.id;
        debugPrint('deliverDocId : ${deliverDocId.value}');
      }),
    });
    driverReportCollection.where(DriverReportModel.dateString, isEqualTo: '').get().then((snapshot) => {
      snapshot.docs.forEach((element) {       // ignore: avoid_function_literals_in_foreach_calls
        driverReportDocId.value = '';
        driverReportDocId.value = element.id;
      }),
    });
  }
  void updateOrderStatus() {
    orderCollection.doc(orderDocId.value).update({OrderModel.isNewString : false}).then((_) => debugPrint('order status is false.'));
  }

  void rejectFunction() {
    newOrderId.value = '';
    //setDriverId();
    //orderCollection.doc(orderDocId.value).update({OrderModel.isNewString : false}).then((_) => debugPrint('update successful.'));
    //deliverCollection.doc(deliverDocId.value).update({DeliverModel.processString : 'Rejected'}).then((_) => debugPrint('order id ${newOrderId.value} was reject.'));
    //deliverCollection.doc(deliverDocId.value).update({DeliverModel.step1String : false, DeliverModel.step2String : false, DeliverModel.step3String : false, DeliverModel.step4String : false}).then((_) => debugPrint('update all step successful.'));
    _timer.cancel();
    Get.offAllNamed('/instruction');
  }
  void setDriverId() {
    _getDocumentId(newOrderId.value);

    DateTime dateTime = DateFormat('dd-MMM-yy').parse(orderDate.value);
    var inputDayFormat = DateFormat('d');
    var inputMonthFormat = DateFormat('M');
    var inputYearFormat = DateFormat('yy');
    var outputDay = inputDayFormat.format(dateTime);
    var outputMonth = inputMonthFormat.format(dateTime);
    var outputYear = inputYearFormat.format(dateTime);

    final tel = mainPageController.readDriverPhoneNumber();
    driverCollection.where(DriverModel.telString, isEqualTo: tel).get().then((value) {

      for (var data in value.docs) {
        final id = data['driver_id'];
        debugPrint('driver Id String: $id');
        orderCollection.doc(orderDocId.value).update({OrderModel.driverIdString : id}).then((_) {
          debugPrint('Order was accept/reject by driver id: $id');
          deliverCollection.doc(deliverDocId.value).update({DeliverModel.driverIdString : id}).then((_){
            debugPrint('deliver was accept/reject by driver id: $id');
          });
        });
        if (driverReportDocId.value != '') {
          driverReportCollection.doc(driverReportDocId.value).update({
            DriverReportModel.driverIdString: id,
            DriverReportModel.dateString: orderDate.value,
            DriverReportModel.dayString: int.parse(outputDay),
            DriverReportModel.monthString: int.parse(outputMonth),
            DriverReportModel.yearString: int.parse(outputYear),
            DriverReportModel.bonusString: '0.00',
            DriverReportModel.deliveryFeeString: '0.00',
            DriverReportModel.distanceString: '0.00',
            DriverReportModel.onlineHourString: '0',
            DriverReportModel.onlineMinuteString: '0',
            DriverReportModel.pointString: '0',
            DriverReportModel.tipString: '0.0',
            DriverReportModel.tripString: '0',
          }).then((_) => debugPrint('driver report was write driver id: $id'));
        }
      }
    });

    // final data = driverCollection.where(DriverModel.telString, isEqualTo: tel).snapshots();
    // data.listen((data) {
    //   final driver = data.docs.map((e) => DriverModel.fromMap(e.data())).toList();
    //   String id = driver[0].driverId;
    //   orderCollection.doc(orderDocId.value).update({OrderModel.driverIdString : id}).then((_) => debugPrint('Order was accept/reject by driver id: $id'));
    //   deliverCollection.doc(deliverDocId.value).update({DeliverModel.driverIdString : id}).then((_) => debugPrint('deliver was accept/reject by driver id: $id'));
    //   if (driverReportDocId.value != '') {
    //     driverReportCollection.doc(driverReportDocId.value).update({
    //       DriverReportModel.driverIdString: id,
    //       DriverReportModel.dateString: orderDate.value,
    //       DriverReportModel.dayString: int.parse(outputDay),
    //       DriverReportModel.monthString: int.parse(outputMonth),
    //       DriverReportModel.yearString: int.parse(outputYear),
    //       DriverReportModel.bonusString: '0.00',
    //       DriverReportModel.deliveryFeeString: '0.00',
    //       DriverReportModel.distanceString: '0.00',
    //       DriverReportModel.onlineHourString: '0',
    //       DriverReportModel.onlineMinuteString: '0',
    //       DriverReportModel.pointString: '0',
    //       DriverReportModel.tipString: '0.0',
    //       DriverReportModel.tripString: '0',
    //     }).then((_) => debugPrint('driver report was write driver id: $id'));
    //   }
    // });
  }
}
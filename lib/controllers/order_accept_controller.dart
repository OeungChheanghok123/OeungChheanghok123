import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class OrderAcceptController extends GetxController{
  final newOrderCardController = Get.put(NewOrderCardController());

  var slideIndex = 0.obs;
  var ratingStar = 0.0.obs;
  var starIcon = Icons.star_border.obs;
  var ratingComment = TextEditingController();

  var step1 = '';
  var step2 = '';
  var step3 = '';
  var step4 = '';
  var orderStep = [];

  var driverId = '';
  var driverDocId = '';
  var deliverDocId = '';
  var driverReportDocId = '';

  var orderDeliveryFee = '0.00'.obs;

  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);
  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);
  final driverReportCollection = FirebaseFirestore.instance.collection(DriverReportModel.collectionName);

  final _driverReportData = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverReportModel>> get data => _driverReportData.value;

  @override
  void onInit() {
    _loadDeliverDocumentId(newOrderCardController.orderId.value);

    step1 = "Arrived Merchant to Pickup (Step: 1/4)";
    step2 = "Picked Order ID: ${newOrderCardController.orderId.value} (Step: 2/4)";
    step3 = "Arrived Customer Area (Step: 3/4)";
    step4 = "Delivered to ${newOrderCardController.customerName.value} (Step: 4/4)";

    orderStep.add(step1);
    orderStep.add(step2);
    orderStep.add(step3);
    orderStep.add(step4);
    super.onInit();
  }

  void sendComment(String comment) {
    debugPrint("star and comment to customer: $ratingStar and comment: $comment");
    Get.back();
    comment = '';
    ratingComment.clear();
    ratingStar.value = 0;
  }
  void updateOrderData() {
    if (slideIndex.value == 1) {
      deliverCollection.doc(deliverDocId).update({DeliverModel.step1String : true}).then((_) => debugPrint('update step 1 successful.'));
    }
    if (slideIndex.value == 2) {
      deliverCollection.doc(deliverDocId).update({DeliverModel.step2String : true}).then((_) => debugPrint('update step 2 successful.'));
    }
    if (slideIndex.value == 3) {
      deliverCollection.doc(deliverDocId).update({DeliverModel.step3String : true}).then((_) => debugPrint('update step 3 successful.'));
    }
    if (slideIndex.value == 4) {
      deliverCollection.doc(deliverDocId).update({DeliverModel.step4String : true}).then((_) => debugPrint('update step 4 successful.'));
      deliverCollection.doc(deliverDocId).update({DeliverModel.processString : 'Delivered'}).then((_) => debugPrint('order is Delivered successful.'));
      setDriverReportData();
    }
  }
  void setDriverReportData() {
    final data = driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: driverId).snapshots();
    data.listen((result) {
      final driverReport = result.docs.map((e) => DriverReportModel.fromMap(e.data())).toList();

      var deliveryFee = double.parse(driverReport[0].deliveryFee);
      debugPrint('orderDeliveryFee: ${orderDeliveryFee.value} deliverFee : $deliveryFee');
      var totalDeliveryFee = deliveryFee + double.parse(orderDeliveryFee.value);

      driverReportCollection.doc(driverReportDocId).update({DriverReportModel.deliveryFeeString : totalDeliveryFee.toStringAsFixed(2)});
    });

  }
  void _loadDeliverDocumentId(String id) {
    deliverCollection.where(DeliverModel.orderIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        deliverDocId = element.id;
        driverId = element['driver_id'];
        _loadDriverDocumentId(driverId);
        _loadDeliverReportDocumentId(driverId);

        orderDeliveryFee.value = element['delivery_fee'];
        debugPrint('orderDeliveryFee is : ${orderDeliveryFee.value}');
      }),
    });
  }
  void _loadDriverDocumentId(String id) {
    driverCollection.where(DriverModel.driverIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        driverDocId = element.id;
      }),
    });
  }
  void _loadDeliverReportDocumentId(String id) {
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        driverReportDocId = element.id;
      }),
    });
  }
}
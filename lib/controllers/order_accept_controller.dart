import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/models/deliver_model.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/driver_report_model.dart';
import 'package:loy_eat/models/order_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class OrderAcceptController extends GetxController{
  final newOrderCardController = Get.put(NewOrderCardController());
  final orderController = Get.put(OrderController());

  var slideIndex = 0.obs;
  var ratingStar = 0.0.obs;
  var starIcon = Icons.star_border.obs;
  var ratingComment = TextEditingController();

  var step1 = '';
  var step2 = '';
  var step3 = '';
  var step4 = '';
  var orderStep = [];

  var orderDate = '';
  var customerName = '';
  var driverId = '';
  var driverDocId = '';
  var deliverDocId = '';
  var driverReportDocId = '';

  var point = '0.00'.obs;
  var orderDistance = '0.00'.obs;

  var orderDeliveryFee = '0.00'.obs;
  var orderBonus = '0.00'.obs;
  var orderTip = '0.00'.obs;

  final deliverCollection = FirebaseFirestore.instance.collection(DeliverModel.collectionName);
  final orderCollection = FirebaseFirestore.instance.collection(OrderModel.collectionName);
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);
  final driverReportCollection = FirebaseFirestore.instance.collection(DriverReportModel.collectionName);

  final _driverReportData = RemoteData<List<DriverReportModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverReportModel>> get data => _driverReportData.value;

  @override
  void onInit() {
    _loadDeliverDocumentId(newOrderCardController.orderId.value);
    newOrderCardController.closeTimer();

    step1 = "Arrived Merchant to Pickup (Step: 1/4)";
    step2 = "Picked Order ID: ${newOrderCardController.orderId.value} (Step: 2/4)";
    step3 = "Arrived Customer Area (Step: 3/4)";
    step4 = "Delivered to ${newOrderCardController.customerName.value} (Step: 4/4)";

    orderStep.add(step1);
    orderStep.add(step2);
    orderStep.add(step3);
    orderStep.add(step4);
    getSlideIndex();
    super.onInit();
  }

  void getSlideIndex() {
    final deliver = deliverCollection.where(DeliverModel.orderIdString, isEqualTo: newOrderCardController.orderId.value).snapshots();
    deliver.listen((event) {
      for (var element in event.docs) {
        var step = 0;
        if (element['step_1'] == false) {
          step = 0;
          slideIndex.value = step;
        } else if (element['step_2'] == false) {
          step = 1;
          slideIndex.value = step;
        } else if (element['step_3'] == false) {
          step = 2;
          slideIndex.value = step;
        } else if (element['step_4'] == false) {
          step = 3;
          slideIndex.value = step;
        }
      }
    });
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
      customerName = newOrderCardController.customerName.value;
      setDriverReportData();
      orderController.orderAccept.value = false;
    }
  }
  void setDriverReportData() {
    _loadDeliverDocumentId(newOrderCardController.orderId.value);
    debugPrint('order date: $orderDate');
    debugPrint('driverId: $driverId');
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: driverId).where(DriverReportModel.dateString, isEqualTo: orderDate).get().then((driverReport){
      // ignore: avoid_function_literals_in_foreach_calls
      driverReport.docs.forEach((data) {
        var point = int.parse(data[DriverReportModel.pointString]);
        var distance = double.parse(data[DriverReportModel.distanceString]);
        var trip = int.parse(data[DriverReportModel.tripString]);
        var deliveryFee = double.parse(data[DriverReportModel.deliveryFeeString]);
        var bonus = double.parse(data[DriverReportModel.bonusString]);
        var tip = double.parse(data[DriverReportModel.tipString]);

        var totalPoint = point + 3;
        var totalDistance = distance + double.parse(orderDistance.value);
        var totalTrip = trip + 1;
        var totalDeliveryFee = deliveryFee + double.parse(orderDeliveryFee.value);
        var totalBonus = bonus + double.parse(orderBonus.value);
        var totalTip = tip + double.parse(orderTip.value);

        debugPrint('totalPoint: $totalPoint');
        debugPrint('totalDistance: $totalDistance');
        debugPrint('totalPoint: $totalPoint');
        debugPrint('totalTrip: $totalTrip');
        debugPrint('totalDeliveryFee: $totalDeliveryFee');
        debugPrint('totalBonus: $totalBonus');

        driverReportCollection.doc(driverReportDocId).update({
          DriverReportModel.pointString : totalPoint.toString(),

          DriverReportModel.distanceString : totalDistance.toStringAsFixed(2),
          DriverReportModel.tripString : totalTrip.toString(),

          DriverReportModel.deliveryFeeString : totalDeliveryFee.toStringAsFixed(2),
          DriverReportModel.bonusString : totalBonus.toStringAsFixed(2),
          DriverReportModel.tipString : totalTip.toStringAsFixed(2),
        });

      });
    });
  }

  void _loadDeliverDocumentId(String id) {
    deliverCollection.where(DeliverModel.orderIdString, isEqualTo: id).get().then((value) {
      value.docs.forEach((element) { // ignore: avoid_function_literals_in_foreach_calls
        deliverDocId = element.id;
        orderDistance.value = element['distance'];
        orderDeliveryFee.value = element['delivery_fee'];
        orderBonus.value = element['bonus'];
        orderTip.value = element['tip'];
      });
    });
    orderCollection.where(OrderModel.orderIdString, isEqualTo: id).get().then((snapshot) {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        driverId = element['driver_id'];
        orderDate = element['date'];
        _loadDriverDocumentId(driverId);
        _loadDeliverReportDocumentId(driverId);
      });
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
    driverReportCollection.where(DriverReportModel.driverIdString, isEqualTo: id).where(DriverReportModel.dateString, isEqualTo: orderDate).get().then((snapshot) => {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        driverReportDocId = element.id;
      }),
    });
  }
}
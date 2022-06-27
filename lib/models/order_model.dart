import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const String collectionName = "orders";
  static const String orderIdString = "order_id";
  static const String customerIdString = "cus_id";
  static const String merchantIdString = "mer_id";
  static const String dateTimeString = "date_time";
  static const String deliveryFeeString = "delivery_fee";
  static const String statusString = "status";
  static const String totalDiscountString = "total_dis";

  late String orderId, customerId, merchantId, dateTime, deliveryFee, status, totalDiscount;
  DocumentReference? reference;

  OrderModel({
    this.orderId = "no orderId",
    this.customerId = "no customerId",
    this.merchantId = "no merchantId",
    this.dateTime = "no dateTime",
    this.deliveryFee = "no delivery fee",
    this.status = "no status",
    this.totalDiscount = "no total discount",
    this.reference,
  });

  OrderModel.fromMap(Object? object, {required this.reference}){
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    orderId = (map ?? {})[orderIdString] ?? "no orderId";
    customerId = (map ?? {})[customerIdString] ?? "no customerId";
    merchantId = (map ?? {})[merchantIdString] ?? "no merchantId";
    dateTime = (map ?? {})[dateTimeString] ?? "no dateTime";
    deliveryFee = (map ?? {})[deliveryFeeString] ?? "no delivery fee";
    status = (map ?? {})[statusString] ?? "no status";
    totalDiscount = (map ?? {})[totalDiscountString] ?? "no total discount";
  }

  OrderModel.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
    orderIdString : orderId,
    customerIdString : customerId,
    merchantIdString : merchantId,
    dateTimeString : dateTime,
    deliveryFeeString : deliveryFee,
    statusString : status,
    totalDiscountString : totalDiscount,
  };
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliverModel {
  static const String collectionName = "delivers";
  static const String orderIdString = "order_id";
  static const String driverIdString = "driver_id";
  static const String dateString = "date";
  static const String bonusString = "bonus";
  static const String customerRatingString = "customer_rating";
  static const String deliveryFeeString = "delivery_fee";
  static const String distanceString = "distance";
  static const String merchantRatingString = "merchant_rating";
  static const String processString = "process";
  static const String timeMinuteString = "time_minute";
  static const String tipString = "tip";

  late String orderId, driverId, date, bonus, customerRating, deliveryFee, distance, merchantRating, process, timeMinute, tip;
  DocumentReference? reference;

  DeliverModel({
    this.orderId = "no orderId",
    this.driverId = "no driverId",
    this.date = "no date",
    this.bonus = "no bonus",
    this.customerRating = "no customer rating",
    this.deliveryFee = "no delivery fee",
    this.distance = "no distance",
    this.merchantRating = "no merchant rating",
    this.process = "no process",
    this.timeMinute = "no time",
    this.tip = "no tip",
    this.reference,
  });

  DeliverModel.fromMap(Object? object, {this.reference}){
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    orderId = (map ?? {})[orderIdString] ?? "no orderId";
    driverId = (map ?? {})[driverIdString] ?? "no driverId";
    date = (map ?? {})[dateString] ?? "no date";
    bonus = (map ?? {})[bonusString] ?? "no bonus";
    customerRating = (map ?? {})[customerRatingString] ?? "no customer rating";
    deliveryFee = (map ?? {})[deliveryFeeString] ?? "no delivery fee";
    distance = (map ?? {})[distanceString] ?? "no distance";
    merchantRating = (map ?? {})[merchantRatingString] ?? "no merchant rating";
    process = (map ?? {})[processString] ?? "no process";
    timeMinute = (map ?? {})[timeMinuteString] ?? "no time";
    tip = (map ?? {})[tipString] ?? "no tip";
  }

  DeliverModel.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
    orderIdString : orderId,
    driverIdString : driverId,
    dateString : date,
    bonusString : bonus,
    customerRatingString : customerRating,
    deliveryFeeString : deliveryFee,
    distanceString : distance,
    merchantRatingString : merchantRating,
    processString : process,
    timeMinuteString : timeMinute,
    tipString : tip,
  };
}
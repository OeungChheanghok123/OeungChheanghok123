import 'package:cloud_firestore/cloud_firestore.dart';

class OrderReportModel {
  static const String collectionName = "order_report";
  static const String onlineString = "online";
  static const String tripString = "trip";
  static const String pointString = "point";
  static const String distanceString = "distance";
  static const String customerRatingString = "customer_rating";
  static const String merchantRatingString = "merchant_rating";
  static const String deliveryFeeString = "delivery_fee";
  static const String bonusString = "bonus";
  static const String tipString = "tip";

  late String online, trip, point, distance, customerRating, merchantRating, deliveryFee, bonus, tip;
  DocumentReference? reference;

  OrderReportModel({
    this.online = "no online",
    this.trip = "no trip",
    this.point = "no point",
    this.distance = "no distance",
    this.customerRating = "no customer rating",
    this.merchantRating = "no merchant rating",
    this.deliveryFee = "no delivery fee",
    this.bonus = "no bonus",
    this.tip = "no tip",
    this.reference,
  });

  OrderReportModel.fromMap(Object? object, {required this.reference}){
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    online = (map ?? {})[onlineString] ?? "no online";
    trip = (map ?? {})[tripString] ?? "no trip";
    point = (map ?? {})[pointString] ?? "no point";
    distance = (map ?? {})[distanceString] ?? "no distance";
    customerRating = (map ?? {})[customerRatingString] ?? "no customer rating";
    merchantRating = (map ?? {})[merchantRatingString] ?? "no merchant rating";
    deliveryFee = (map ?? {})[deliveryFeeString] ?? "no deliveryFee";
    bonus = (map ?? {})[bonusString] ?? "no bonus";
    tip = (map ?? {})[tipString] ?? "no tip";
  }

  OrderReportModel.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
    onlineString : online,
    tripString : trip,
    pointString : point,
    distanceString : distance,
    customerRatingString : customerRating,
    merchantRatingString : merchantRating,
    deliveryFeeString : deliveryFee,
    bonusString : bonus,
    tipString : tip,
  };
}
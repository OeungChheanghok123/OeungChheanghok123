// class ReportModel{
//   String online;
//   int trips ;
//   int points;
//   String distance;
//   String customerRating;
//   String merchantRating;
//   double deliveryFee;
//   double bonus;
//   double tip;
//
//   ReportModel({
//     this.online = '60h:22m',
//     this.trips = 50,
//     this.points = 400,
//     this.distance = '150Km',
//     this.customerRating = '4.5/5 rating',
//     this.merchantRating = '5/5 rating',
//     this.deliveryFee = 120,
//     this.bonus = 21.25,
//     this.tip = 11,
//   });
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  static const String collectionName = "delivers";
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
  DocumentReference reference;

  ReportModel({
    this.online = "no online",
    this.trip = "no trip",
    this.point = "no point",
    this.distance = "no distance",
    this.customerRating = "no customer rating",
    this.merchantRating = "no merchant rating",
    this.deliveryFee = "no delivery fee",
    this.bonus = "no bonus",
    this.tip = "no tip",
    required this.reference,
  });

  ReportModel.fromMap(Object? object, {required this.reference}){
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

  ReportModel.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data(), reference: snapshot.reference);

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
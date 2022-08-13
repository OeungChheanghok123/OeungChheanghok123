import 'dart:convert';

class DriverReportModel {
  static const String collectionName = "driver_reports";
  static const String driverIdString = "driver_id";
  static const String dateString = "date";
  static const String bonusString = "bonus";
  static const String deliveryFeeString = "delivery_fee";
  static const String distanceString = "distance";
  static const String customerRatingString = "customer_rating";
  static const String merchantRatingString = "merchant_rating";
  static const String tipString = "tip";
  static const String onlineHourString = "online_hour";
  static const String onlineMinuteString = "online_minute";
  static const String pointString = "point";
  static const String tripString = "trip";

  int driverId;
  String date;
  String bonus;
  String deliveryFee;
  String distance;
  String customerRating;
  String merchantRating;
  String tip;
  String onlineHour;
  String onlineMinute;
  String point;
  String trip;
  
  DriverReportModel({
    required this.driverId,
    required this.date,
    required this.bonus,
    required this.deliveryFee,
    required this.distance,
    required this.customerRating,
    required this.merchantRating,
    required this.tip,
    required this.onlineHour,
    required this.onlineMinute,
    required this.point,
    required this.trip,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({driverIdString: driverId});
    result.addAll({dateString: date});
    result.addAll({bonusString: bonus});
    result.addAll({deliveryFeeString: deliveryFee});
    result.addAll({distanceString: distance});
    result.addAll({customerRatingString: customerRating});
    result.addAll({merchantRatingString: merchantRating});
    result.addAll({tipString: tip});
    result.addAll({onlineHourString: onlineHour});
    result.addAll({onlineMinuteString: onlineMinute});
    result.addAll({pointString: point});
    result.addAll({tripString: trip});
  
    return result;
  }

  factory DriverReportModel.fromMap(Map<String, dynamic> map) {
    return DriverReportModel(
      driverId: map[driverIdString]?.toInt() ?? 0,
      date: map[dateString] ?? '',
      bonus: map[bonusString] ?? '',
      deliveryFee: map[deliveryFeeString] ?? '',
      distance: map[distanceString] ?? '',
      customerRating: map[customerRatingString] ?? '',
      merchantRating: map[merchantRatingString] ?? '',
      tip: map[tipString] ?? '',
      onlineHour: map[onlineHourString] ?? '',
      onlineMinute: map[onlineMinuteString] ?? '',
      point: map[pointString] ?? '',
      trip: map[tripString] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverReportModel.fromJson(String source) => DriverReportModel.fromMap(json.decode(source));
}

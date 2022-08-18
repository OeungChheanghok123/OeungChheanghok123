import 'dart:convert';

class OrderModel {
  static const String collectionName = "orders";
  static const String customerIdString = "customer_id";
  static const String customerNameString = "customer_name";
  static const String dateString = "date";
  static const String isNewString = "is_new";
  static const String merchantIdString = "merchant_id";
  static const String merchantNameString = "merchant_name";
  static const String orderIdString = "order_id";
  static const String statusString = "status";
  static const String timeString = "time";
  static const String totalDiscountString = "total_discount";

  String customerId;
  String customerName;
  String date;
  bool isNew;
  String merchantId;
  String merchantName;
  String orderId;
  String status;
  String time;
  String totalDiscount;

  OrderModel({
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.isNew,
    required this.merchantId,
    required this.merchantName,
    required this.orderId,
    required this.status,
    required this.time,
    required this.totalDiscount,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({customerIdString: customerId});
    result.addAll({customerNameString: customerName});
    result.addAll({dateString: date});
    result.addAll({isNewString: isNew});
    result.addAll({merchantIdString: merchantId});
    result.addAll({merchantNameString: merchantName});
    result.addAll({orderIdString: orderId});
    result.addAll({statusString: status});
    result.addAll({timeString: time});
    result.addAll({totalDiscountString: totalDiscount});
  
    return result;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      customerId: map[customerIdString] ?? '',
      customerName: map[customerNameString] ?? '',
      date: map[dateString] ?? '',
      isNew: map[isNewString] ?? false,
      merchantId: map[merchantIdString] ?? '',
      merchantName: map[merchantNameString] ?? '',
      orderId: map[orderIdString] ?? '',
      status: map[statusString] ?? '',
      time: map[timeString] ?? '',
      totalDiscount: map[totalDiscountString] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));
}
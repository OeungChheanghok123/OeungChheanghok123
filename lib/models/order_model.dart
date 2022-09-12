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
  static const String driverIdString = "driver_id";

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
  String driverId;

  OrderModel({
    this.customerId = '',
    this.customerName = '',
    this.date = '',
    this.isNew = false,
    this.merchantId = '',
    this.merchantName = '',
    this.orderId = '',
    this.status = '',
    this.time = '',
    this.totalDiscount = '',
    this.driverId = '',
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
    result.addAll({driverIdString: driverId});

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
      driverId: map[driverIdString] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));
}
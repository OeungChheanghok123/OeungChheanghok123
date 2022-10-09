import 'dart:convert';

class OrderDetailModel {
  static const String collectionName = "orders_detail";
  static const String orderIdString = "order_id";
  static const String itemsString = "items";

  String orderId;
  List<Map<String, dynamic>> items;

  OrderDetailModel({
    required this.orderId,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({orderIdString: orderId});
    result.addAll({itemsString: items});
  
    return result;
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      orderId: map[orderIdString] ?? '',
      items: List<Map<String, dynamic>>.from(map[itemsString]?.map((x) => Map<String, dynamic>.from(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) => OrderDetailModel.fromMap(json.decode(source));
}

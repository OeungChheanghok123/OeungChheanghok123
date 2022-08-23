import 'dart:convert';

class ProductModel {
  static const String collectionName = "products";
  static const String merchantIdString = "merchant_id";
  static const String productIdString = "product_id";
  static const String productNameString = "product_name";
  static const String detailString = "detail";
  static const String priceString = "price";
  static const String createAtString = "create_at";

  String merchantId;
  String productId;
  String productName;
  String detail;
  String price;
  String createAt;

  ProductModel({
    this.merchantId = '',
    this.productId = '',
    this.productName = '',
    this.detail = '',
    this.price = '',
    this.createAt = '',
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({merchantIdString: merchantId});
    result.addAll({productIdString: productId});
    result.addAll({productNameString: productName});
    result.addAll({detailString: detail});
    result.addAll({priceString: price});
    result.addAll({createAtString: createAt});

    return result;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      merchantId: map[merchantIdString],
      productId: map[productIdString],
      productName: map[productNameString],
      detail: map[detailString],
      price: map[priceString],
      createAt: map[createAtString],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));
}
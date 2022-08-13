import 'dart:convert';

class MerchantModel {
  static const String collectionName = "merchants";
  static const String merchantIdString = "merchant_id";
  static const String merchantNameString = "merchant_name";
  static const String imageString = "image";
  static const String locationString = "location";
  static const String telString = "tel";
  static const String createAtString = "create_at";

  String merchantId;
  String merchantName;
  String image;
  String location;
  String tel;
  String createAt;

  MerchantModel({
    required this.merchantId,
    required this.merchantName,
    required this.image,
    required this.location,
    required this.tel,
    required this.createAt,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({merchantIdString: merchantId});
    result.addAll({merchantNameString: merchantName});
    result.addAll({imageString: image});
    result.addAll({locationString: location});
    result.addAll({telString: tel});
    result.addAll({createAtString: createAt});

    return result;
  }

  factory MerchantModel.fromMap(Map<String, dynamic> map) {
    return MerchantModel(
      merchantId: map[merchantIdString] ?? '',
      merchantName: map[merchantNameString] ?? '',
      image: map[imageString] ?? '',
      location: map[locationString] ?? '',
      tel: map[telString] ?? '',
      createAt: map[createAtString] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MerchantModel.fromJson(String source) => MerchantModel.fromMap(json.decode(source));
}

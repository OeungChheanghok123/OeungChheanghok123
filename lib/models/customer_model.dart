import 'dart:convert';

class CustomerModel {
  static const String collectionName = "customers";
  static const String customerIdString = "customer_id";
  static const String customerNameString = "customer_name";
  static const String imageString = "image";
  static const String genderString = "gender";
  static const String locationString = "location";
  static const String telString = "tel";
  static const String createAtString = "create_at";
  static const String createTimeString = "create_time";

  String customerId; 
  String customerName;
  String image;
  String gender; 
  String location; 
  String tel; 
  String createAt;
  String createTime;

  CustomerModel({
    required this.customerId,
    required this.customerName,
    required this.image,
    required this.gender,
    required this.location,
    required this.tel,
    required this.createAt,
    required this.createTime,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({customerIdString: customerId});
    result.addAll({customerNameString: customerName});
    result.addAll({imageString: image});
    result.addAll({genderString: gender});
    result.addAll({locationString: location});
    result.addAll({telString: tel});
    result.addAll({createAtString: createAt});
    result.addAll({createTimeString: createTime});

    return result;
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      customerId: map[customerIdString] ?? '',
      customerName: map[customerNameString] ?? '',
      image: map[imageString] ?? '',
      gender: map[genderString] ?? '',
      location: map[locationString] ?? '',
      tel: map[telString] ?? '',
      createAt: map[createAtString] ?? '',
      createTime: map[createTimeString] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) => CustomerModel.fromMap(json.decode(source));
}

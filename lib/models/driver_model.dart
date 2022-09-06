import 'dart:convert';

class DriverModel {
  static const String collectionName = "drivers";
  static const String yobString = "YOB";
  static const String createAtString = "create_at";
  static const String driverIdString = "driver_id";
  static const String driverNameString = "driver_name";
  static const String genderString = "gender";
  static const String idCardString = "id_card";
  static const String imageString = "image";
  static const String locationString = "location";
  static const String referralCodeString = "referral_code";
  static const String shiftString = "shift";
  static const String statusString = "status";  
  static const String telString = "tel";
  static const String isOnlineString = "is_online";

  String yob;
  String createAt;
  String driverId;
  String driverName;
  String gender;
  String idCard;
  String image;
  String location;
  String referralCode;
  String shift;
  String status;
  String tel;
  bool isOnline;

  DriverModel({
    this.yob = '',
    this.createAt = '',
    this.driverId = '',
    this.driverName = '',
    this.gender = '',
    this.idCard = '',
    this.image = '',
    this.location = '',
    this.referralCode = '',
    this.shift = '',
    this.status = '',
    this.tel = '',
    this.isOnline = false,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({yobString: yob});
    result.addAll({createAtString: createAt});
    result.addAll({driverIdString: driverId});
    result.addAll({driverNameString: driverName});
    result.addAll({genderString: gender});
    result.addAll({idCardString: idCard});
    result.addAll({imageString: image});
    result.addAll({locationString: location});
    result.addAll({referralCodeString: referralCode});
    result.addAll({shiftString: shift});
    result.addAll({statusString: status});
    result.addAll({telString: tel});
    result.addAll({isOnlineString: isOnline});

    return result;
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      yob: map[yobString] ?? '',
      createAt: map[createAtString] ?? '',
      driverId: map[driverIdString] ?? '',
      driverName: map[driverNameString] ?? '',
      gender: map[genderString] ?? '',
      idCard: map[idCardString] ?? '',
      image: map[imageString] ?? '',
      location: map[locationString] ?? '',
      referralCode: map[referralCodeString] ?? '',
      shift: map[shiftString] ?? '',
      status: map[statusString] ?? '',
      tel: map[telString] ?? '',
      isOnline: map[isOnlineString] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverModel.fromJson(String source) => DriverModel.fromMap(json.decode(source));
}
import 'package:cloud_firestore/cloud_firestore.dart';

List<CustomerModel> getCustomerFromSnapshot(List<QueryDocumentSnapshot> docs){
  return docs.map((e) => CustomerModel.fromSnapshot(e)).toList();
}

class CustomerModel {
  static const String collectionName = "customers";
  static const String customerIdString = "cus_id";
  static const String customerNameString = "cus_name";
  static const String genderString = "gender";
  static const String locationString = "location";
  static const String telString = "tel";
  static const String createAtString = "create_at";
  static const String updateAtString = "update_at";

  late String customerId, customerName, gender, location, tel, createAt, updateAt;
  DocumentReference? reference;

  CustomerModel({
    this.customerId = "no cus_id",
    this.customerName = "no cus_name",
    this.gender = "no gender",
    this.location = "no location",
    this.tel = "no tel",
    this.createAt = "no create_at",
    this.updateAt = "no update_at",
    this.reference,
  });

  CustomerModel.fromMap(Object? object, {required this.reference}){
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    customerId = (map ?? {})[customerIdString] ?? "no cus_id";
    customerName = (map ?? {})[customerNameString] ?? "no cus_name";
    gender = (map ?? {})[genderString] ?? "no gender";
    location = (map ?? {})[locationString] ?? "no location";
    tel = (map ?? {})[telString] ?? "no tel";
    createAt = (map ?? {})[createAtString] ?? "no create_at";
    updateAt = (map ?? {})[updateAtString] ?? "no update_at";
  }

  CustomerModel.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
    customerIdString : customerId,
    customerNameString : customerName,
    genderString : gender,
    locationString : location,
    telString : tel,
    createAtString : createAt,
    updateAtString : updateAt,
  };
}
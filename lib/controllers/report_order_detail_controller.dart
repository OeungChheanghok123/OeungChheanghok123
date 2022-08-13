import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReportOrderDetailController extends GetxController{

  var customer = CustomerProfile();
  var remarkController = TextEditingController();
  var getOrderNo = ''.obs;
}

class CustomerProfile{
  String image;
  String name;
  String address;
  String phoneNumber;

  CustomerProfile({
    this.image = 'assets/image/driver_profile.png',
    this.name = 'Chheanghok',
    this.address = '#23, St.344, SangKat DangKor, Khan DangKor',
    this.phoneNumber = '011425717',
  });
}
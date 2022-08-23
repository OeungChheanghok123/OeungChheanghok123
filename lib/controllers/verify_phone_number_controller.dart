import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class VerifyPhoneNumberController extends GetxController {
  var allPhoneNumberList = [];
  var phoneNumber = '';
  var verificationIDReceived = '';

  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();

  final _driverData = RemoteData<List<DriverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverModel>> get data => _driverData.value;

  void verifyNumber() {
    List phone = phoneController.text.split("");

    if(phone[0] == "0"){
      phone.removeAt(0);
    }

    phoneController.text = phone.join();
    phoneNumber = phone.join();

    auth.verifyPhoneNumber(
      phoneNumber: "+855${phoneController.text}",
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) async{
        await auth.signInWithCredential(credential).then((value) => {
          debugPrint('You are logged in successfully'),
        });
      },
      verificationFailed: (FirebaseAuthException exception){
        debugPrint(exception.message);
      },
      codeSent: (String verificationID, int? resendToken){
        verificationIDReceived = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID){},
    );
  }
  void loadAllPhoneNumber() {
    try {
      final data = FirebaseFirestore.instance.collection(DriverModel.collectionName).snapshots();
      data.listen((result) {
        final driver = result.docs.map((e) => DriverModel.fromMap(e.data())).toList();
        _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.success, data: driver);

        for (var e in driver) {
          allPhoneNumberList.add(e.tel);
        }
        debugPrint('all Phone Number list : $allPhoneNumberList');
        for (int i = 0 ; i < allPhoneNumberList.length ; i++) {
          String num = allPhoneNumberList[i];
          if (num == phoneController.text) {
            debugPrint('successful login : $num');
            Get.toNamed('/enter_otp_code');
            verifyNumber();
            break;
          } else {
            debugPrint('failed login : $num');
            Get.toNamed('/become_driver_fail');
          }
        }
      });
    } catch (ex) {
      _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}
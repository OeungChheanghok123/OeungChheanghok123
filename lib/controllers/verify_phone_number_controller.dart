import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/driver_model.dart';

class VerifyPhoneNumberController extends GetxController {
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);
  var phoneNumber = ''.obs;
  var verificationIDReceived = '';

  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  final mainPageController = Get.put(MainPageController());

  void loadAllPhoneNumber() {
    List phone = phoneController.text.split("");

    if (phone[0] == "0") {
      phone.removeAt(0);
    }

    phoneController.text = phone.join();
    phoneNumber.value = phone.join();

    final driver = driverCollection.where(DriverModel.telString, isEqualTo: phoneNumber.value).where(DriverModel.statusString, isEqualTo: 'Approved').snapshots();
    driver.listen((result) {
      if (result.docs.isNotEmpty) {
        debugPrint('phoneNumber is : $phoneNumber');
        mainPageController.writeDriverPhoneNumber(phoneNumber.value);
        verifyNumber();
      }
      else {
        final driver = driverCollection.where(DriverModel.telString, isEqualTo: phoneNumber.value).where(DriverModel.statusString, isEqualTo: '').snapshots();
        driver.listen((result) {
          if (result.docs.isNotEmpty) {
            Get.toNamed('/log_in_fail', arguments: {'message': 'Your phone number is not yet approved!\nPlease try again later! Thanks.'});
          }
          else {
            Get.toNamed('/log_in_fail', arguments: {'message': 'Your phone number is not yet register!\nPlease try to register before login! Thanks.'});
          }
        });
      }
    });
  }
  verifyNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: "+855${phoneController.text}",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        auth.signInWithCredential(credential).then((value) => debugPrint('You are logged in successfully'));
      },
      verificationFailed: (FirebaseAuthException exception){
        debugPrint(exception.message);
      },
      codeSent: (String verificationID, int? resendToken){
        verificationIDReceived = verificationID;
        Get.toNamed('/enter_otp_code');
      },
      codeAutoRetrievalTimeout: (String verificationID){},
    );
  }
}
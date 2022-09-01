import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/driver_model.dart';

class VerifyPhoneNumberController extends GetxController {
  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);
  var driverDoc = '';
  var allPhoneNumberList = [];
  var phoneNumber = '';
  var verificationIDReceived = '';

  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  final homeController = Get.put(HomeController());
  final mainPageController = Get.put(MainPageController());

  void editPhoneNumber() {
    List phone = phoneController.text.split("");

    if(phone[0] == "0"){
      phone.removeAt(0);
    }

    phoneController.text = phone.join();
    phoneNumber = phone.join();

    driverCollection.where(DriverModel.telString, isEqualTo: phoneNumber).get().then((snapshot) => {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((element) {
        driverDoc = element.id;
      }),
      driverCollection.doc(driverDoc).update({DriverModel.isLogString : true}).then((_) => debugPrint('is log = true.')),
    });

  }
  void verifyNumber() {
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

        for (var e in driver) {
          allPhoneNumberList.add(e.tel);
        }

        editPhoneNumber();

        for (int i = 0 ; i < allPhoneNumberList.length ; i++) {
          String num = allPhoneNumberList[i];
          if (num == phoneNumber) {
            mainPageController.writeLogin(true);
            Get.toNamed('/enter_otp_code');
            verifyNumber();
            break;
          } else {
            Get.toNamed('/log_in_fail');
          }
        }
      });
    } catch (ex) {
      debugPrint("Load All Phone Number Error: $ex");
    }
  }
}
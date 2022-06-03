import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyPhoneNumberController extends GetxController {

  var phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var verificationIDReceived = '';

}
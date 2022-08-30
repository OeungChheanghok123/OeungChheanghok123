import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/fire_base_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageController extends GetxController{
  final firebaseNotifications = FirebaseNotifications();

  Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint(message.data.toString());
    debugPrint(message.notification!.title);
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
  void loadFirebaseNotification(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      firebaseNotifications.setupFirebase(context);
    });
  }

  late SharedPreferences _preferences;
  final String _isLogKey  =  "isLog";

  void init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  Future<bool> write(bool value) {
     return _preferences.setBool(_isLogKey, value);
  }
  bool read() {
    return _preferences.getBool(_isLogKey) ?? false;
  }
  void remove() {
    _preferences.remove(_isLogKey);
  }
}
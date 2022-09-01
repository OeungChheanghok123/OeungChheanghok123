import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/fire_base_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageController extends GetxController{
  SharedPreferences? preferences;
  final String _isLogKey = "isLog";
  final String _language = "language";
  final String _languageCode = "languageCode";
  final String _countryCode = "countryCode";
  final firebaseNotifications = FirebaseNotifications();

  @override
  void onInit() {
    super.onInit();
    init();
  }
  Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<bool>? writeLogin(bool value) {
    return preferences?.setBool(_isLogKey, value);
  }
  bool readLogin() {
    return preferences?.getBool(_isLogKey) ?? false;
  }
  void removeLogin() {
    preferences?.remove(_isLogKey);
  }

  Future<bool>? writeLanguage(String value) {
    return preferences?.setString(_language, value);
  }
  String readLanguage() {
    return preferences?.getString(_language) ?? "";
  }
  void removeLanguage() {
    preferences?.remove(_language);
  }

  Future<bool>? writeLanguageCode(String value) {
    return preferences?.setString(_languageCode, value);
  }
  Future<bool>? writeCountryCode(String value) {
    return preferences?.setString(_countryCode, value);
  }
  String readLanguageCode() {
    return preferences?.getString(_languageCode) ?? "en";
  }
  String readCountryCode() {
    return preferences?.getString(_countryCode) ?? "US";
  }
  void removeCode() {
    preferences?.remove(_languageCode);
    preferences?.remove(_countryCode);
  }

  void loadFirebaseNotification(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      firebaseNotifications.setupFirebase(context);
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/fire_base_notification.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/remote_data.dart';

class MainPageController extends GetxController{
  final isLog = false.obs;
  final firebaseNotifications = FirebaseNotifications();

  final _driverData = RemoteData<List<DriverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverModel>> get driverData => _driverData.value;

  Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint(message.data.toString());
    debugPrint(message.notification!.title);
  }

  @override
  void onInit() {
    _loadDriverData();
    super.onInit();
  }
  void loadFirebaseNotification(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      firebaseNotifications.setupFirebase(context);
    });
  }
  void _loadDriverData() {
    try {
      final data = FirebaseFirestore.instance.collection(DriverModel.collectionName).where(DriverModel.isLogString, isEqualTo: true).snapshots();
      data.listen((result) {
        final drivers = result.docs.map((e) => DriverModel.fromMap(e.data())).toList();
        _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.success, data: drivers);
        if (drivers.isNotEmpty) {
          isLog.value = true;
        } else {
          isLog.value = false;
        }
      });
    } catch (ex) {
      _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
}
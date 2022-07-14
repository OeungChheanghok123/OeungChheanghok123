import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/notification_model.dart';
import 'package:loy_eat/screens/notification_detail_screen.dart';

class FirebaseNotifications {
  int messageCount = 1;
  String lastMessageId = "";
  //var globalNotificationId;   // ignore: prefer_typing_uninitialized_variables
  late BuildContext myContext;

  void setupFirebase(BuildContext context) {
    LocalNotificationService.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  CollectionReference notification = FirebaseFirestore.instance.collection('notification');

  void firebaseCloudMessageListener(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((remoteMessage){
      //globalNotificationId = remoteMessage.data['ref_id'];
      if (Platform.isAndroid) {
        if (lastMessageId != remoteMessage.messageId) {
          notification.add({
            'title': remoteMessage.data['title'],
            'body': remoteMessage.data['body'],
            'isRead': false,
            'ref_id':remoteMessage.data['ref_id'],
            'date': remoteMessage.data['date'],
            'dri_id': remoteMessage.data['dri_id'],
          }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error")); // ignore: avoid_print
          notification.where("isRead", isEqualTo: false).get().then((value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
        }
      }
      if (Platform.isIOS) {
        if (lastMessageId != remoteMessage.messageId) {
          notification.add({
            'title':remoteMessage.data['title'], // John Doe
            'body': "Testing body", // Stokes and Sons
            'isRead': false,
            'ref_id':remoteMessage.data['ref_id'],
            'date': remoteMessage.data['date'],
            'dri_id': remoteMessage.data['dri_id'],
          }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error")); // ignore: avoid_print
          notification.where("isRead", isEqualTo: false).get().then((value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
        }
      }

      lastMessageId = remoteMessage.messageId!;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (Platform.isAndroid) {
        if (lastMessageId != remoteMessage.messageId) {
          notification.add({
            'title': remoteMessage.data['title'],
            'body': remoteMessage.data['body'],
            'isRead': false,
            'ref_id':remoteMessage.data['ref_id'],
            'date': remoteMessage.data['date'],
            'dri_id': remoteMessage.data['dri_id'],
          }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error")); // ignore: avoid_print
          notification.where("isRead", isEqualTo: false).get().then((value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
        }
      }
      if (Platform.isIOS) {
        if (lastMessageId != remoteMessage.messageId) {
          notification.add({
            'title':remoteMessage.data['title'], // John Doe
            'body': "Testing body", // Stokes and Sons
            'isRead': false,
            'ref_id':remoteMessage.data['ref_id'],
            'date': remoteMessage.data['date'],
            'dri_id': remoteMessage.data['dri_id'],
          }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error")); // ignore: avoid_print
          notification.where("isRead", isEqualTo: false).get().then((value) => FlutterAppBadger.updateBadgeCount(value.docs.length));
        }
      }

      lastMessageId = remoteMessage.messageId!;

      Future.delayed(const Duration(seconds: 2), () {
        Get.to(NotificationDetailScreen(refId: remoteMessage.data['ref_id']));
      });
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = const AndroidNotificationDetails(
      "com.example.loy_eat", "My channel",
      autoCancel: false,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannel = const IOSNotificationDetails();
    var platForm = NotificationDetails(android: androidChannel, iOS: iosChannel);
    await LocalNotificationService.notificationsPlugin.show(0, title, body, platForm, payload: "my payload");
  }
}

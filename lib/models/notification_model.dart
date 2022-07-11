import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.pushNamed(context, route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try{
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails  notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "One Sala",
          "One Sala",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data["route"],
      );

    } on Exception catch(e) {
      print(e); // ignore: avoid_print
    }
  }
}








class NotificationModel {
  String title;
  String subTile;
  String date;
  Color color;

  NotificationModel({
    required this.title,
    required this.subTile,
    required this.date,
    this.color = rabbit,
  });
}

List<NotificationModel> listNotification = [
  NotificationModel(title: 'Big Discount "Green Tea"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '10 Feb'),
  NotificationModel(title: 'Big Discount "Amazon"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '11 Feb'),
  NotificationModel(title: '80% off from Zando TK', subTile: '80% OFF Zando Coupons | Save Up To \$50 with amazon.com Discount Code For April 2022', date: '12 Feb'),
  NotificationModel(title: 'Big Discount "Milk Tea"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '13 Feb'),
  NotificationModel(title: '80% off from Zando SR', subTile: '80% OFF Zando Coupons | Save Up To \$50 with amazon.com Discount Code For April 2022', date: '14 Feb'),
  NotificationModel(title: 'Big Discount "coconut milk tea special"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '10 Feb'),
  NotificationModel(title: 'Big Discount "iced late"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '11 Feb'),
  NotificationModel(title: '80% off from Zando Prey Veng', subTile: '80% OFF Zando Coupons | Save Up To \$50 with amazon.com Discount Code For April 2022', date: '12 Feb'),
  NotificationModel(title: 'Big Discount "Fan ta"', subTile: 'Happy Khmer Year 2022, Amazon store will close from 13-Apr to 17-Apr 2022.', date: '13 Feb'),
  NotificationModel(title: '80% off from Borey Meanchey', subTile: '80% OFF Zando Coupons | Save Up To \$50 with amazon.com Discount Code For April 2022', date: '14 Feb'),
];
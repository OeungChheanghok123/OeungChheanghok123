import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static late BuildContext myContext;

  static Future<void> initNotification(BuildContext context) async {
    myContext = context;
    var initAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = const IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    var initSetting = InitializationSettings(android: initAndroid,iOS: initIOS);

    notificationsPlugin.initialize(initSetting, onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String? payload){
    throw payload!;
  }

  static Future onDidReceiveLocalNotification(int? id,String? title,String? body, String? payload) async {
    showDialog(context: myContext, builder: (context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("OK"),
          onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
        ),
      ],
    ));
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
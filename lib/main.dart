import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/controllers/page_controller.dart';
import 'package:loy_eat/models/languages.dart';
import 'package:loy_eat/screens/instruction_screen.dart';
import 'package:loy_eat/screens/start_up_screen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint(message.data.toString());
  debugPrint(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    controller.loadFirebaseNotification;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Locale(controller.readLanguageCode(), controller.readCountryCode()),
      fallbackLocale: Locale(controller.readLanguageCode(), controller.readCountryCode()),
      title: "Loy Eat driver app",
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: getRoutPage,
      home: controller.readLogin() ? const InstructionScreen() : StartUpScreen(),
    );
  }
}
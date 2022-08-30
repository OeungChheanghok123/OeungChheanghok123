import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/controllers/page_controller.dart';
import 'package:loy_eat/models/languages.dart';
import 'package:loy_eat/screens/instruction_screen.dart';
import 'package:loy_eat/screens/start_up_screen.dart';

final controller = Get.put(MainPageController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(controller.backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.firebaseNotifications;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: "Loy Eat driver app",
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: getRoutPage,
      home: controller.read() ? const InstructionScreen() : const StartUpScreen(),
    );
  }
}
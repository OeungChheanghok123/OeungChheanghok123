import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/page_controller.dart';
import 'package:loy_eat/models/languages.dart';
import 'package:loy_eat/screens/instruction_screen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString()); // ignore: avoid_print
  print(message.notification!.title); // ignore: avoid_print
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: "Loy Eat driver app for BuyLoy.com",
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: getRoutPage,
      home: const InstructionScreen(),
    );
  }
}
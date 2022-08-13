import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/bindings/controller_binding.dart';
import 'package:loy_eat/controllers/page_controller.dart';
import 'package:loy_eat/fire_base_notification.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) async {
      firebaseNotifications.setupFirebase(context);
    });
  }

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
      initialBinding: ControllerBinding(),
      getPages: getRoutPage,
      home: const InstructionScreen(),
    );
  }
}
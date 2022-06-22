import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/page_controller.dart';
import 'package:loy_eat/models/languages.dart';
import 'package:loy_eat/screens/instruction_screen.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return _buildMaterial(
            const Scaffold(
              body: Center(
                child: TextWidget(
                  text: "Error Firebase",
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done){
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
        } else {
          return _buildMaterial(
            const Center(
              child: Scaffold(
                body: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  _buildMaterial(Widget home){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: "Loy Eat driver app for BuyLoy.com",
      initialRoute: "/",
      defaultTransition: Transition.noTransition,
      getPages: getRoutPage,
      home: home,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loy_eat/models/languages.dart';
import 'package:loy_eat/screens/become_driver_fail_screen.dart';
import 'package:loy_eat/screens/become_driver_screen.dart';
import 'package:loy_eat/screens/become_driver_success_screen.dart';
import 'package:loy_eat/screens/edit_profile_screen.dart';
import 'package:loy_eat/screens/enter_otp_screen.dart';
import 'package:loy_eat/screens/feedback_screen.dart';
import 'package:loy_eat/screens/instruction_screen.dart';
import 'package:loy_eat/screens/invite_friend_screen.dart';
import 'package:loy_eat/screens/login_screen.dart';
import 'package:loy_eat/screens/qr_code_screen.dart';
import 'package:loy_eat/screens/rating_score_screen.dart';
import 'package:loy_eat/screens/report_order_detail_screen.dart';
import 'package:loy_eat/screens/start_up_screen.dart';
import 'package:loy_eat/screens/support_screen.dart';
import 'package:loy_eat/screens/verify_phone_number_screen.dart';
import 'package:loy_eat/screens/notification_screen.dart';
import 'package:loy_eat/widgets/screen_widget/auto_complete_text_field.dart';

void main() => runApp(const MyApp());

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
      getPages: [
        GetPage(name: '/start_up', page: () => const StartUpScreen()),
        GetPage(name: '/log_in', page: () => const LoginScreen()),
        GetPage(name: '/become_driver', page: () => const BecomeDriverScreen()),
        GetPage(name: '/verify_phone_number', page: () => const VerifyPhoneNumberScreen()),
        GetPage(name: '/enter_otp_code', page: () => const EnterOTPCodeScreen()),
        GetPage(name: '/instruction', page: () => const InstructionScreen()),
        GetPage(name: '/notification', page: () => const NotificationScreen(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 500)),
        GetPage(name: '/become_driver_success', page: () => const BecomeDriverSuccessScreen()),
        GetPage(name: '/become_driver_fail', page: () => const BecomeDriverFailScreen()),
        GetPage(name: '/auto_complete_text_field', page: () => const AutoCompleteTextField(), transition: Transition.downToUp),
        GetPage(name: '/edit_profile', page: () => const EditProfileScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/rating_score', page: () => const RatingScoreScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/invite_friend', page: () => const InviteFriendScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/support', page: () => const SupportScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/feedback_us', page: () => const FeedbackUsScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/qr_code', page: () => const QRCodeScreen(), transition: Transition.rightToLeftWithFade),
        GetPage(name: '/report_order_detail', page: () => const ReportOrderDetailScreen(), transition: Transition.rightToLeftWithFade),
      ],
      home: StartUpScreen(key: key),
    );
  }
}
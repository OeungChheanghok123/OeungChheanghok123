import 'package:get/get.dart';
import 'package:loy_eat/screens/become_driver_fail_screen.dart';
import 'package:loy_eat/screens/become_driver_screen.dart';
import 'package:loy_eat/screens/become_driver_success_screen.dart';
import 'package:loy_eat/screens/edit_profile_screen.dart';
import 'package:loy_eat/screens/enter_otp_screen.dart';
import 'package:loy_eat/screens/feedback_screen.dart';
import 'package:loy_eat/screens/home_screen.dart';
import 'package:loy_eat/screens/instruction_screen.dart';
import 'package:loy_eat/screens/invite_friend_screen.dart';
import 'package:loy_eat/screens/login_fail_screen.dart';
import 'package:loy_eat/screens/login_screen.dart';
import 'package:loy_eat/screens/order_accept.dart';
import 'package:loy_eat/screens/order_screen.dart';
import 'package:loy_eat/screens/qr_code_screen.dart';
import 'package:loy_eat/screens/rating_score_screen.dart';
import 'package:loy_eat/screens/report_order_detail_screen.dart';
import 'package:loy_eat/screens/start_up_screen.dart';
import 'package:loy_eat/screens/support_screen.dart';
import 'package:loy_eat/screens/verify_phone_number_screen.dart';
import 'package:loy_eat/screens/notification_screen.dart';
import 'package:loy_eat/widgets/screen_widget/auto_complete_text_field.dart';
import 'package:loy_eat/widgets/screen_widget/order_empty_screen.dart';

List<GetPage<dynamic>>? getRoutPage = [
  GetPage(name: '/start_up', page: () => StartUpScreen()),
  GetPage(name: '/log_in', page: () => const LoginScreen()),
  GetPage(name: '/become_driver', page: () => const BecomeDriverScreen()),
  GetPage(name: '/verify_phone_number', page: () => VerifyPhoneNumberScreen()),
  GetPage(name: '/enter_otp_code', page: () => const EnterOTPCodeScreen()),
  GetPage(name: '/instruction', page: () => const InstructionScreen()),
  GetPage(name: '/home', page: () => HomeScreen()),
  GetPage(name: '/notification', page: () => const NotificationScreen(), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 500)),
  //GetPage(name: '/notification_detail', page: () => NotificationDetailScreen(notificationIndex: homeController.notificationIndex.value), transition: Transition.rightToLeftWithFade, transitionDuration: const Duration(milliseconds: 500)),
  GetPage(name: '/become_driver_success', page: () => const BecomeDriverSuccessScreen()),
  GetPage(name: '/become_driver_fail', page: () => const BecomeDriverFailScreen()),
  GetPage(name: '/auto_complete_text_field', page: () => const AutoCompleteTextField(), transition: Transition.downToUp),
  GetPage(name: '/edit_profile', page: () => const EditProfileScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/rating_score', page: () => const RatingScoreScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/invite_friend', page: () => const InviteFriendScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/support', page: () => const SupportScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/feedback_us', page: () => const FeedbackUsScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/qr_code', page: () => const QRCodeScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/report_order_detail', page: () => ReportOrderDetailScreen(), transition: Transition.rightToLeftWithFade),
  GetPage(name: '/order_empty', page: () => OrderEmptyScreen()),
  GetPage(name: '/order_accept', page: () => OrderAccept()),
  GetPage(name: '/order', page: () => OrderScreen()),
  GetPage(name: '/become_driver_fail', page: () => const BecomeDriverFailScreen()),
  GetPage(name: '/log_in_fail', page: () => const LoginFailScreen()),
];
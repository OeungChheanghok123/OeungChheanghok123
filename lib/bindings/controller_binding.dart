import 'package:get/get.dart';
import 'package:loy_eat/controllers/home_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}
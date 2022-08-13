import 'package:get/get.dart';
import 'package:loy_eat/controllers/new_order_card_controller.dart';

class OrderAcceptController extends GetxController{

  final newOrderCardController = Get.put(NewOrderCardController());

  List<String> orderStep = [
    "Arrived to Pickup (Step: 1/4)",
    "Picked Order ID: 123456 (Step: 2/4)",
    "Arrived Customer Area (Step: 3/4)",
    "Delivered to Sovongdy (Step: 4/4)",
  ].obs;

  @override
  void onInit() {
    newOrderCardController.closeTimer();
    super.onInit();
  }
}
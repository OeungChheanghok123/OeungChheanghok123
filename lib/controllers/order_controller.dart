import 'package:get/get.dart';

class OrderController extends GetxController{

  var orderEmpty = "Sorry, No order yet!";
  var orderCancelByCustomer = "You won't be paid for this delivery, but we will try to find another trip.";
  var reasonCustomerCancel = "Sorry! Order #123456 for Sovongdy has been canceled due to ...";
  var reasonMerchantCancel = "Sorry! Order #123456 has been canceled by Cafe Amazon (PPIU) due to ...";

  var orderAccept = false.obs;
}
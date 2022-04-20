import 'package:get/get.dart';

class RatingScoreController extends GetxController{
  var titleText = 'Rating Score';

  var totalScorePercentage = 82.5.obs;
  var totalCustomerPercentage = 80.obs;
  var totalMerchantPercentage = 85.obs;

  var feedbackAllCounter = 12.obs;
  var feedbackCustomerCounter = 10.obs;
  var feedbackMerchantCounter = 2.obs;
}
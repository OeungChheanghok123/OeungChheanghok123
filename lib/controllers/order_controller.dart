import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class OrderController extends GetxController{

  var orderEmpty = "Sorry, No order yet!";
  var orderCancelByCustomer = "You won't be paid for this delivery, but we will try to find another trip.";
  var reasonCustomerCancel = "Sorry! Order #123456 for Sovongdy has been canceled due to ...";
  var reasonMerchantCancel = "Sorry! Order #123456 has been canceled by Cafe Amazon (PPIU) due to ...";

  var ratingStar = 0.0.obs;
  var starIcon = Icons.star_border.obs;
  var ratingComment = TextEditingController();

  void showDialogRateToCustomer() {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 0,
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      content: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 8),
              child: InkWell(
                splashColor: none,
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: silver.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const IconWidget(
                    icon: Icons.close,
                    color: red,
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: rabbit,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const IconWidget(
                  icon: Icons.check,
                  color: white,
                  size: 50,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const TextWidget(
                text: "Thank You",
                fontWeight: FontWeight.w500,
                size: 14,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const TextWidget(
                text: "Your trip is now delivered!",
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const TextWidget(
                text: "How was your experience with Sovongdy?",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: RatingBar.builder(
                initialRating: ratingStar.value,
                itemSize: 32,
                itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                updateOnDrag: true,
                itemBuilder: (context, index) => const IconWidget(icon: Icons.star, size: 32,),
                onRatingUpdate: (rating) => ratingStar.value = rating,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFieldWidget(
                controller: ratingComment,
                height: 40,
                inputType: TextInputType.text,
                hintText: 'Write your comment',
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ButtonWidget(
                height: 35,
                width: 150,
                borderRadius: 5,
                onPressed: () => sendComment(ratingComment.text),
                child: const TextWidget(
                  isTitle: true,
                  text: "Submit",
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void sendComment(String comment) {
    print("star and comment to customer:$ratingStar and $comment"); // ignore: avoid_print
    Get.back();
    comment = '';
    ratingComment.clear();
    ratingStar.value = 0;
  }
}
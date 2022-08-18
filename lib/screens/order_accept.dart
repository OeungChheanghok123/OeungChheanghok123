import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/order_accept_controller.dart';
import 'package:loy_eat/controllers/order_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/google_map.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class OrderAccept extends StatelessWidget {
  OrderAccept({Key? key}) : super(key: key);

  final orderAcceptController = Get.put(OrderAcceptController());
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            _buildGoogleMap,
            _buildSliderButton,
          ],
        ),
      ),
    );
  }

  Widget get _buildGoogleMap {
    return Container(
      margin: const EdgeInsets.only(bottom: 65),
      child: const GoogleMapWidget(),
    );
  }
  Widget get _buildSliderButton {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: none,
          child: ConfirmationSlider(
            height: 50,
            backgroundColor: rabbit,
            backgroundShape: BorderRadius.circular(5.0),
            foregroundColor: white.withOpacity(0.5),
            foregroundShape: BorderRadius.circular(5.0),
            text: orderAcceptController.orderStep[orderAcceptController.slideIndex.value],
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: white,
            ),
            onConfirmation: () {
              orderAcceptController.slideIndex.value++;
              orderAcceptController.updateOrderData();
              if (orderAcceptController.slideIndex.value == 4) {
                orderAcceptController.slideIndex.value--;
                showDialogRateToCustomer();
              }
            },
          ),
        ),
      ),
    );
  }

  void showDialogRateToCustomer() {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 0,
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      content: _buildBodyDialog,
    );
  }
  Widget get _buildBodyDialog {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        //buttonCloseWidget,
        iconCheckWidget,
        _buildTextWidget(
          marginTop: 15,
          text: 'Thank You',
        ),
        _buildTextWidget(
          marginTop: 5,
          text: 'Your trip is now delivered!',
        ),
        _buildTextWidget(
          marginTop: 30,
          text: 'How was your experience with Sovongdy?',
          textAlign: TextAlign.center,
        ),
        startRatingWidget,
        textFieldCommentWidget,
        //buttonSubmit(orderAcceptController.ratingComment),
      ],
    );
  }

  Widget get buttonCloseWidget {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 8),
      child: InkWell(
        splashColor: none,
        onTap: () {
          orderController.isNewOrder.value = false;
          Get.offNamed('/instruction');
        },
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
    );
  }
  Widget get iconCheckWidget {
    return Container(
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
    );
  }
  Widget _buildTextWidget({required double marginTop, required String text, TextAlign textAlign = TextAlign.start}) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: TextWidget(
        text: text,
        textAlign: textAlign,
      ),
    );
  }
  Widget get startRatingWidget {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: RatingBar.builder(
        initialRating: orderAcceptController.ratingStar.value,
        itemSize: 32,
        itemPadding: const EdgeInsets.symmetric(horizontal: 5),
        updateOnDrag: true,
        itemBuilder: (context, index) => const IconWidget(icon: Icons.star, size: 32,),
        onRatingUpdate: (rating) => orderAcceptController.ratingStar.value = rating,
      ),
    );
  }
  Widget get textFieldCommentWidget {
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFieldWidget(
        controller: orderAcceptController.ratingComment,
        height: 40,
        inputType: TextInputType.text,
        hintText: 'Write your comment',
      ),
    );
  }
  Widget buttonSubmit(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ButtonWidget(
        height: 35,
        width: 150,
        borderRadius: 5,
        onPressed: (){
          orderAcceptController.sendComment(controller.text);
          orderController.isNewOrder.value = false;
          Get.offNamed('/instruction');
        },
        child: const TextWidget(
          isTitle: true,
          text: "Submit",
          color: white,
        ),
      ),
    );
  }
}
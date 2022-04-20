import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/feedback_us_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class FeedbackUsScreen extends StatefulWidget {
  const FeedbackUsScreen({Key? key}) : super(key: key);

  @override
  _FeedbackUsScreenState createState() => _FeedbackUsScreenState();
}

class _FeedbackUsScreenState extends State<FeedbackUsScreen> {

  FeedbackUsController feedbackUsController = Get.put(FeedbackUsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar:  AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            splashColor: none,
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: feedbackUsController.titleText),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTextTitle,
              _buildGuildLine,
              _buildButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildTextTitle{
    return const SizedBox(
      width: 280,
      child: TextWidget(
        textAlign: TextAlign.center,
        text: 'Please share your experience and make any suggestion for the following questions:',
      ),
    );
  }
  Widget get _buildGuildLine{
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 0,
                  child: TextWidget(
                    text: '1. ',
                  ),
                ),
                Expanded(
                  child: TextWidget(
                    text: 'How would you rate your experience with us?',
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                const TextWidget(text: 'Very dissatisfied'),
                Container(
                  width: 85,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index){
                      return _buildRatingNumber(index + 1);
                    },
                  ),
                ),
                const TextWidget(text: 'Very satisfied'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  flex: 0,
                  child: TextWidget(
                    text: '2. ',
                  ),
                ),
                Expanded(
                  child: TextWidget(
                    text: 'What ares do you wants us to improve further in order to service you better?',
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: TextFieldWidget(
              controller: feedbackUsController.textFieldController,
              inputType: TextInputType.text,
              height: 80,
              maxLine: 5,
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
  Widget get _buildButton{
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ButtonWidget(
        onPressed: (){
          print('Driver feedback: ' + feedbackUsController.textFieldController.text); // ignore: avoid_print
          Get.back();
        },
        width: 250,
        borderRadius: 25.0,
        child: const TextWidget(
          isTitle: true,
          text: 'Submit',
          color: white,
        ),
      ),
    );
  }

  Widget _buildRatingNumber(int index){
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        border: Border.all(color: silver, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: TextWidget(
          text: '$index',
          size: 9,
        ),
      ),
    );
  }
}

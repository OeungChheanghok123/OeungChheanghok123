import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/account_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/svg_picture_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildDriverDetail,
              _buildMenu,
              _buildButtonLogout,
            ],
          ),
        ),
        bottomSheet: Container(
          color: white,
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.topCenter,
          child: const TextWidget(
            text: 'Version 0.1.0',
            color: silver,
          ),
        ),
      ),
    );
  }

  Widget get _buildDriverDetail{
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(35, 20, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: rabbit,
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(accountController.userProfile.value),
                    ),
                  ),
                ),
                Row(
                  children: const [
                    IconWidget(icon: Icons.image_rounded, size: 16, color: silver),
                    Space(),
                    IconWidget(icon: Icons.photo_camera_rounded, size: 16, color: silver),
                  ],
                ),
              ],
            ),
            const Space(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(isTitle: true, text: accountController.driverName.value),
                const Space(height: 10),
                TextWidget(text: accountController.phoneNumber.value, color: silver),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget get _buildMenu{
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      child: Column(
        children: [
          _buildMenuItem(Icons.person_rounded, 'Edit Profile', '/edit_profile'),
          _buildMenuItem(Icons.reviews_rounded, 'Rating Score', '/rating_score'),
          _buildMenuItem(Icons.loyalty_outlined, 'Invite Friends to Earn Points', '/invite_friend'),
          _buildMenuItem(Icons.help_outlined, 'Need a Support', '/support'),
          _buildMenuItem(Icons.rate_review_outlined, 'Feedback Us', '/feedback_us'),
          _buildLanguage(Icons.language_outlined, 'Language'),
        ],
      ),
    );
  }
  Widget get _buildButtonLogout{
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: ButtonWidget(
        onPressed: () => exit(0),
        height: 40,
        width: MediaQuery.of(context).size.width,
        color: lightGray,
        child: const TextWidget(
          isTitle: true,
          text: 'Logout',
          color: rabbit,
        ),
      ),
    );
  }
  Future get showDialog{
    return Get.defaultDialog(
      backgroundColor: white,
      radius: 5,
      title: "Language",
      titlePadding: const EdgeInsets.only(top: 15, bottom: 10),
      titleStyle: const TextStyle(
        fontSize: 16,
      ),
      content: Column(
        children: [
          Obx(() => _buildItemLanguage(
            1,
            accountController.khmerImage.value,
            'Khmer Language',
            accountController.khmerLabel.value,
            accountController.radioColorKhmer.value,
          ),),
          const Space(height: 15),
          Obx(() => _buildItemLanguage(
            2,
            accountController.ukImage.value,
            'English Language',
            accountController.ukLabel.value,
            accountController.radioColorEnglish.value,
          ),),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData leadingIcon, String text, String page){
    return Column(
      children: [
        InkWell(
          splashColor: none,
          onTap: () => Get.toNamed(page),
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconWidget(icon: leadingIcon, size: 25),
                    const Space(width: 15),
                    TextWidget(text: text),
                  ],
                ),
                const IconWidget(
                  icon: Icons.arrow_forward_ios_rounded,
                  size: 22,
                  color: black,
                ),
              ],
            ),
          ),
        ),
        Container(
          color: silver,
          height: 1,
          margin: const EdgeInsets.only(bottom: 5),
        ),
      ],
    );
  }
  Widget _buildLanguage(IconData leadingIcon, String text){
    return Column(
      children: [
        InkWell(
          splashColor: none,
          onTap: () => showDialog,
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconWidget(icon: leadingIcon, size: 25),
                    const Space(width: 15),
                    TextWidget(text: text),
                  ],
                ),
                Row(
                  children: [
                    Obx(() => Container(
                      width: 35,
                      height: 20,
                      margin: const EdgeInsets.only(right: 10),
                      child: SvgPictureWidget(
                        imageString: accountController.defaultLanguage.value,
                        label: 'default language',
                      ),
                    ),),
                    const IconWidget(
                      icon: Icons.arrow_forward_ios_rounded,
                      size: 22,
                      color: black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: silver,
          height: 1,
        ),
      ],
    );
  }
  Widget _buildItemLanguage(int index, String image, String labelImage, String text, Color colorChecker){
    return InkWell(
      splashColor: none,
      onTap: () => accountController.selectItemLanguage(index),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: silver)
              ),
              child: Container(
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: colorChecker,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            SizedBox(
              width: 25,
              height: 20,
              child: SvgPictureWidget(
                imageString: image,
                label: labelImage,
              ),
            ),
            const Space(width: 15),
            TextWidget(text: text, size: 14),
          ],
        ),
      ),
    );
  }
}

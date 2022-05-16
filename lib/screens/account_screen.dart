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
        backgroundColor: lightGray,
        appBar: null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildDriverDetail,
              Card(
                elevation: 1,
                borderOnForeground: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    _buildMenu,
                    _buildVersion,
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: _buildButtonLogout,
      ),
    );
  }

  Widget get _buildDriverDetail{
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 1,
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(35, 20, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: none,
              highlightColor: none,
              onTap: (){},
              child: Stack(
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
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: silver,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const IconWidget(
                          icon: Icons.photo_camera_rounded,
                          size: 12,
                          color: black,
                        ),
                      )
                  ),
                ],
              ),
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
          _buildMenuItem(Icons.person_rounded, 'Edit Profile'.tr, '/edit_profile'),
          _buildMenuItem(Icons.reviews_rounded, 'Rating Score'.tr, '/rating_score'),
          _buildMenuItem(Icons.loyalty_outlined, 'Invite Friends to Earn Points'.tr, '/invite_friend'),
          _buildMenuItem(Icons.help_outlined, 'Need a Support'.tr, '/support'),
          _buildMenuItem(Icons.rate_review_outlined, 'Feedback Us'.tr, '/feedback_us'),
          _buildLanguage(Icons.language_outlined, 'Language'.tr),
        ],
      ),
    );
  }
  Widget get _buildVersion{
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.topCenter,
      child: const TextWidget(
        text: 'Version 0.1.0',
        color: silver,
      ),
    );
  }
  Widget get _buildButtonLogout{
    return Container(
      color: lightGray,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
      child: ButtonWidget(
        onPressed: () => exit(0),
        width: MediaQuery.of(context).size.width,
        color: platinum.withOpacity(0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconWidget(
              icon: Icons.logout,
              color: black.withOpacity(0.5),
              size: 18,
            ),
            const Space(width: 10),
            TextWidget(
              text: 'Log out'.tr,
              color: black.withOpacity(0.5),
              size: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        )
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
                IconWidget(
                  icon: Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: silver.withOpacity(0.5),
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
                      width: 30,
                      height: 20,
                      margin: const EdgeInsets.only(right: 15),
                      child: SvgPictureWidget(
                        imageString: accountController.defaultLanguage.value,
                        label: 'default language',
                      ),
                    ),),
                    IconWidget(
                      icon: Icons.arrow_forward_ios_rounded,
                      color: black.withOpacity(0.5),
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: silver.withOpacity(0.5),
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

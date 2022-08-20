import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/account_controller.dart';
import 'package:loy_eat/controllers/verify_phone_number_controller.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/svg_picture_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/screen_widget/screen_widgets.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  final accountController = Get.put(AccountController());
  final verifyPhoneNumberController = Get.put(VerifyPhoneNumberController());

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
              _buildDriverProfileWidget,
              _buildCardSettingWidget,
            ],
          ),
        ),
        bottomSheet: _buildButtonLogout,
      ),
    );
  }

  Widget get _buildDriverProfileWidget{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        const TextWidget(text: 'Profile', fontWeight: FontWeight.bold, size: 14),
        Card(
          margin: const EdgeInsets.only(top: 5),
          elevation: 1,
          borderOnForeground: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: _buildProfileCardWidget,
        ),
      ],
    );
  }
  Widget get _buildProfileCardWidget {
    return Obx(() {
      final status = accountController.driverData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = accountController.driverData.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: report.length,
          itemBuilder: _profileCard,
        );
      }
    });
  }
  Widget _profileCard(BuildContext context, int index) {
    final report = accountController.driverData.data![index];
    return _profileCardItem(report);
  }
  Widget _profileCardItem(DriverModel driverModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 20, 0, 15),
      child: Row(
        children: [
          driverProfile(driverModel.image),
          const Space(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(isTitle: true, text: driverModel.driverName),
              const Space(height: 10),
              TextWidget(text: '0${driverModel.tel}', color: silver),
            ],
          ),
        ],
      ),
    );
  }
  Widget driverProfile(String image) {
    return InkWell(
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
                image: AssetImage(image),
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
    );
  }

  Widget get _buildCardSettingWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const TextWidget(text: 'Setting', fontWeight: FontWeight.bold, size: 14),
        Card(
          elevation: 1,
          borderOnForeground: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              _buildMenu,
              _buildVersion,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _buildMenu{
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
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
          onTap: (){
            if(accountController.defaultLanguage.value == accountController.khmerImage.value){
              accountController.radioColorKhmer.value = rabbit;
              accountController.radioColorEnglish.value = white;
            } else{
              accountController.radioColorKhmer.value = white;
              accountController.radioColorEnglish.value = rabbit;
            }
            showDialog;
          },
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

  Widget get _buildVersion{
    return Container(
      width: double.infinity,
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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
      child: ButtonWidget(
        onPressed: () => exit(0),
        width: double.infinity,
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
      titleStyle: const TextStyle(fontSize: 16),
      content: _buildContentWidget,
    );
  }
  Widget get _buildContentWidget {
    return Column(
      children: [
        Obx(() => _buildItemLanguage(
          1,
          accountController.khmerImage.value,
          'Khmer Language',
          accountController.khmerLabel.value,
          accountController.radioColorKhmer.value,
        )),
        const Space(height: 15),
        Obx(() => _buildItemLanguage(
          2,
          accountController.ukImage.value,
          'English Language',
          accountController.ukLabel.value,
          accountController.radioColorEnglish.value,
        ),),
      ],
    );
  }
  Widget _buildItemLanguage(int index, String image, String labelImage, String text, Color colorChecker){
    return InkWell(
      splashColor: none,
      onTap: () => selectItemLanguage(index),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          children: [
            _buildRadioChecker(colorChecker),
            _buildImageLanguage(image, labelImage),
            _buildTextLanguage(text),
          ],
        ),
      ),
    );
  }
  Widget _buildRadioChecker(Color colorChecker) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 2, color: silver),
      ),
      child: Container(
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: colorChecker,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
  Widget _buildImageLanguage(String image, String labelImage) {
    return SizedBox(
      width: 25,
      height: 20,
      child: SvgPictureWidget(
        imageString: image,
        label: labelImage,
      ),
    );
  }
  Widget _buildTextLanguage(String text) {
    return Row(
      children: [
        const Space(width: 15),
        TextWidget(text: text, size: 14),
      ],
    );
  }

  void selectItemLanguage(int index) {
    Get.back();
    Get.defaultDialog(
      radius: 5,
      title: '',
      titleStyle: const TextStyle(fontSize: 10),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(bottom: 5),
      middleTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      middleText: 'The app will be restarted.',
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      confirmTextColor: rabbit,
      cancelTextColor: text,
      buttonColor: none,
      onCancel: () => Get.back(),
      onConfirm: () {
        accountController.onConfirmSelectingLanguage(index);
        Get.offAllNamed('/instruction');
        Get.back();
      },
    );
  }
}
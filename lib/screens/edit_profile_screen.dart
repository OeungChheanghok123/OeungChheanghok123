import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/edit_profile_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/image_icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  EditProfileController editProfileController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.arrow_back_ios,
              color: black,
              size: 24,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          title: TitleAppBarWidget(text: editProfileController.title),
        ),
        body:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDriverName,
              _buildDriverMobilePhone,
              _buildDriverVehicle,
              _buildDriverSchedule,
              _buildDriverWorkPerWeek,
              _buildSubmitButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildDriverName{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            isTitle: true,
            text: 'Name:',
          ),
          TextFieldWidget(
            controller: editProfileController.driverNameController,
            height: 35,
            inputType: TextInputType.text,
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverMobilePhone{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const TextWidget(
            isTitle: true,
            text: 'Mobile Phone:',
          ),
          TextFieldWidget(
            controller: editProfileController.phoneNumberController,
            height: 35,
            inputType: TextInputType.number,
            hintText: editProfileController.hintPhoneNumber.value,
            hintColor: silver,
            isSuffixIcon: true,
            suffixIcon: const Icon(Icons.check_circle, color: rabbit),
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverVehicle{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TextWidget(
          isTitle: true,
          text: 'Choose your vehicle:',
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _buildVehicleButton(0, 'assets/image/bike_icon.png', 'Bike', editProfileController.bikeBorderVehicleColor.value, editProfileController.bikeBackgroundVehicleColor.value)),
              Obx(() => _buildVehicleButton(1, 'assets/image/motor_icon.png', 'Motor', editProfileController.motorBorderVehicleMotorColor.value, editProfileController.motorBackgroundVehicleBikeColor.value)),
              Obx(() => _buildVehicleButton(2, 'assets/image/rickshaw_icon.png', 'Rickshaw', editProfileController.rickshawBorderVehicleBikeColor.value, editProfileController.rickshawBackgroundVehicleBikeColor.value)),
            ],
          ),
        ),
      ],
    );
  }
  Widget get _buildDriverSchedule{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            isTitle: true,
            text: 'Your time available:',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _buildButtonSchedule(
                  0,
                  'Morning',
                  editProfileController.morningTextScheduleColor.value,
                  editProfileController.morningBackgroundScheduleColor.value,
                  editProfileController.morningBorderScheduleColor.value)),
              Obx(() => _buildButtonSchedule(
                  1,
                  'Afternoon',
                  editProfileController.afternoonTextScheduleColor.value,
                  editProfileController.afternoonBackgroundScheduleColor.value,
                  editProfileController.afternoonBorderScheduleColor.value)),
              Obx(() => _buildButtonSchedule(
                  2,
                  'Evening',
                  editProfileController.eveningTextScheduleColor.value,
                  editProfileController.eveningBackgroundScheduleColor.value,
                  editProfileController.eveningBorderScheduleColor.value)),
            ],
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverWorkPerWeek{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => _buildButtonWeek(0, 'Mon', editProfileController.monTextColor.value, editProfileController.monBackColor.value)),
          Obx(() => _buildButtonWeek(1, 'Tue', editProfileController.tueTextColor.value, editProfileController.tueBackColor.value)),
          Obx(() => _buildButtonWeek(2, 'Wed', editProfileController.wedTextColor.value, editProfileController.wedBackColor.value)),
          Obx(() => _buildButtonWeek(3, 'Thu', editProfileController.thuTextColor.value, editProfileController.thuBackColor.value)),
          Obx(() => _buildButtonWeek(4, 'Fri', editProfileController.friTextColor.value, editProfileController.friBackColor.value)),
          Obx(() => _buildButtonWeek(5, 'Sat', editProfileController.satTextColor.value, editProfileController.satBackColor.value)),
          Obx(() => _buildButtonWeek(6, 'Sun', editProfileController.sunTextColor.value, editProfileController.sunBackColor.value)),
        ],
      ),
    );
  }
  Widget get _buildSubmitButton{
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child:  ButtonWidget(
        onPressed: () => Get.back(),
        child: const TextWidget(
          isTitle: true,
          text: 'Change',
          color: white,
        ),
      ),
    );
  }

  Widget _buildVehicleButton(int index, String image, String text, Color borderColor, Color backgroundColor) => InkWell(
    splashColor: none,
    onTap: () => editProfileController.selectVehicle(index),
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
      child: Row (
        children: [
          ImageIconWidget(
            image: image,
            borderColor: borderColor,
            backgroundColor: backgroundColor,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextWidget(
              text: text,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _buildButtonSchedule(int index, String text, Color textColor, Color buttonColor, Color borderColor) => Container(
    width: 100,
    height: 35,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ButtonWidget(
      onPressed: () => editProfileController.selectScheduleTime(index),
      color: buttonColor,
      borderSide: BorderSide(
        color: borderColor,
        width: 1,
      ),
      child: TextWidget(
        text: text,
        color: textColor,
      ),
    ),
  );
  Widget _buildButtonWeek(int index, String text, Color textColor, Color buttonColor) => InkWell(
    splashColor: none,
    onTap: () => editProfileController.selectScheduleWeek(index),
    child: Container(
      width: 40,
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextWidget(
          text: text,
          color: textColor,
        ),
      ),
    ),
  );
}
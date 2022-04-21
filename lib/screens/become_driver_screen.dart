import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/become_driver_controller.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/image_icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/radio_button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class BecomeDriverScreen extends StatefulWidget {
  const BecomeDriverScreen({Key? key}) : super(key: key);

  @override
  State<BecomeDriverScreen> createState() => _BecomeDriverScreenState();
}

class _BecomeDriverScreenState extends State<BecomeDriverScreen> {

  BecomeDriverController becomeDriverController = Get.put(BecomeDriverController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: null,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDriverName,
                _buildDriverGenderAndBirthYear,
                _buildDriverMobilePhone,
                _buildDriverVehicle,
                //_buildDriverAddress,
                _buildDriverSchedule,
                _buildDriverIDCard,
                _buildDriverReferral,
                _buildSubmitButton,
              ],
            ),
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
            controller: becomeDriverController.driverNameController,
            height: 35,
            inputType: TextInputType.text,
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverGenderAndBirthYear{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                isTitle: true,
                text: 'Gender:',
              ),
              Row(
                children: [
                  Obx(() => _buildRadioButton(0, 'Male')),
                  const Space(width: 10),
                  Obx(() => _buildRadioButton(1, 'Female')),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const TextWidget(
                isTitle: true,
                text: 'Birth Year:',
              ),
              SizedBox(
                width: 100,
                height: 45,
                child: TextFieldWidget(
                  controller: becomeDriverController.birthDayController,
                  inputType: TextInputType.datetime,
                  height: 50,
                  hintText: '2000',
                  textAlign: TextAlign.center,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
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
        children: [
          const TextWidget(
            isTitle: true,
            text: 'Mobile Phone:',
          ),
          TextFieldWidget(
            controller: becomeDriverController.phoneNumberController,
            height: 35,
            inputType: TextInputType.number,
            hintText: 'Enter your phone number',
            hintColor: silver,
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverVehicle{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: const TextWidget(
              isTitle: true,
              text: 'Choose your vehicle:',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _buildVehicleButton(0, 'assets/image/bike_icon.png', 'Bike', becomeDriverController.bikeBorderVehicleColor.value, becomeDriverController.bikeBackgroundVehicleColor.value)),
              Obx(() => _buildVehicleButton(1, 'assets/image/motor_icon.png', 'Motor',  becomeDriverController.motorBorderVehicleMotorColor.value, becomeDriverController.motorBackgroundVehicleBikeColor.value)),
              Obx(() => _buildVehicleButton(2, 'assets/image/rickshaw_icon.png', 'Rickshaw',  becomeDriverController.rickshawBorderVehicleBikeColor.value, becomeDriverController.rickshawBackgroundVehicleBikeColor.value)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget get _buildDriverAddress{
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         const TextWidget(
  //           isTitle: true,
  //           text: 'Where do you live?',
  //         ),
  //         SizedBox(
  //           width: double.infinity,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildDropdownButton(0, 'Districts', menuDistrictItems),
  //               _buildDropdownButton(1, 'Communes', menuCommuneItems),
  //             ],
  //           ),
  //         ),
  //         const Space(height: 10),
  //       ],
  //     ),
  //   );
  // }

  // Widget get _buildDriverAddress{
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         const TextWidget(
  //           isTitle: true,
  //           text: 'Where do you live?',
  //         ),
  //         SizedBox(
  //           width: double.infinity,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildDropdownButton(),
  //               _buildDropdownButton(),
  //             ],
  //           ),
  //         ),
  //         const Space(height: 10),
  //       ],
  //     ),
  //   );
  // }

  Widget get _buildDriverSchedule{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  becomeDriverController.morningTextScheduleColor.value,
                  becomeDriverController.morningBackgroundScheduleColor.value,
                  becomeDriverController.morningBorderScheduleColor.value)),
              Obx(() => _buildButtonSchedule(
                  1,
                  'Afternoon',
                  becomeDriverController.afternoonTextScheduleColor.value,
                  becomeDriverController.afternoonBackgroundScheduleColor.value,
                  becomeDriverController.afternoonBorderScheduleColor.value)),
              Obx(() => _buildButtonSchedule(
                  2,
                  'Evening',
                  becomeDriverController.eveningTextScheduleColor.value,
                  becomeDriverController.eveningBackgroundScheduleColor.value,
                  becomeDriverController.eveningBorderScheduleColor.value)),
            ],
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverIDCard{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  <Widget>[
        const TextWidget(
          isTitle: true,
          text: 'Take your ID card photo:',
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ButtonWidget(
            width: MediaQuery.of(context).size.width,
            height: 120,
            onPressed: () => print('take photo is clicked'), // ignore_for_file: avoid_print
            color: platinum,
            child: const IconWidget(
              icon: Icons.photo_camera,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }
  Widget get _buildDriverReferral{
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TextWidget(
          isTitle: true,
          text: 'Referral code if have:',
        ),
        SizedBox(
          width: 120,
          height: 50,
          child: TextFieldWidget(
            controller: becomeDriverController.referralCodeController,
            height: 50,
            inputType: TextInputType.number,
            textAlign: TextAlign.center,
            hintText: 'Enter code',
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
  Widget get _buildSubmitButton{
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child:  ButtonWidget(
        height: 40,
        onPressed: () => Get.offAllNamed('/become_driver_success'),
        borderRadius: 25,
        child: const TextWidget(
          isTitle: true,
          text: 'Submit',
          color: white,
        ),
      ),
    );
  }

  Widget _buildRadioButton(int index, String text) => InkWell(
    splashColor: none,
    onTap: () => becomeDriverController.selectGender(index),
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        children: [
          RadioButtonWidget(
            index: index,
            groupValue: becomeDriverController.radioGenderValue.value,
            onChanged: (newValue) => becomeDriverController.radioGenderValue.value = newValue,
          ),
          const Space(width: 8),
          TextWidget(text: text),
        ],
      ),
    ),
  );
  Widget _buildVehicleButton(int index, String image, String text, Color borderColor, Color backgroundColor) => InkWell(
    splashColor: none,
    onTap: () => becomeDriverController.selectVehicle(index),
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
  Widget _buildButtonSchedule(int index, String text, Color textColor, Color backgroundColor, Color borderColor) => Container(
    width: 100,
    height: 35,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ButtonWidget(
      onPressed: () => becomeDriverController.selectSchedule(index),
      color: backgroundColor,
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

  // Widget _buildDropdownButton(){
  //   return DropDownTextField(
  //     //initialValue: "name4",
  //     validator: (value){
  //       if (value == 'name4') {
  //         return "Required field";
  //       } else {
  //         return null;
  //       }
  //     },
  //     dropDownList: [
  //       DropDownValueModel(name: 'name1', value: "value1"),
  //       DropDownValueModel(name: 'name2', value: "value2"),
  //       DropDownValueModel(name: 'name3', value: "value3"),
  //       DropDownValueModel(name: 'name4', value: "value4"),
  //       DropDownValueModel(name: 'name5', value: "value5"),
  //       DropDownValueModel(name: 'name6', value: "value6"),
  //       DropDownValueModel(name: 'name7', value: "value7"),
  //       DropDownValueModel(name: 'name8', value: "value8"),
  //     ],
  //     maxItemCount: 6,
  //     onChanged: (val) {
  //       print(val);
  //     },
  //   );
  // }

  // Widget _buildDropdownButton(int index, String hintText, List<String> menuItems){
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     decoration: BoxDecoration(
  //       color: white,
  //       border: Border.all(color: silver, width: 1),
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //     child: DropdownButton<String>(
  //       value: index == 0 ? _dropDownDistrictValue : _dropDownCommuneValue,
  //       hint: TextWidget(text: hintText),
  //       items: menuItems.map((String value) =>
  //           DropdownMenuItem<String>(
  //             value: value,
  //             child: TextWidget(text: value),
  //           ),
  //       ).toList(),
  //       borderRadius: BorderRadius.circular(5),
  //       dropdownColor: white,
  //       alignment: AlignmentDirectional.center,
  //       isDense: true,
  //       itemHeight: null,
  //       menuMaxHeight: 300,
  //       underline: Container(),
  //       onChanged: (String? newValue){
  //         if (newValue != null){
  //           if (index == 0){
  //             setState(() {
  //               _dropDownDistrictValue = newValue;
  //             });
  //           }
  //           else {
  //             setState(() {
  //               _dropDownCommuneValue = newValue;
  //             });
  //           }
  //         }
  //       },
  //     ),
  //   );
  // }
}
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/controllers/become_driver_controller.dart';
import 'package:loy_eat/models/location_model.dart';
import 'package:loy_eat/widgets/layout_widget/button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/image_icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/radio_button_widget.dart';
import 'package:loy_eat/widgets/layout_widget/space.dart';
import 'package:loy_eat/widgets/layout_widget/text_field_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';

class BecomeDriverScreen extends StatelessWidget {
  BecomeDriverScreen({Key? key}) : super(key: key);

  final becomeDriverController = Get.put(BecomeDriverController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: appBar,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDriverName,
                _buildDriverGenderAndBirthYear,
                _buildIdCard,
                _buildDriverMobilePhone,
                _buildDriverVehicle,
                _buildDriverAddress,
                _buildDriverSchedule,
                _buildDriverReferral,
                _buildSubmitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
  final appBar = AppBar(
    elevation: 0,
    title: const TextWidget(text: 'Become Driver', isTitle: true, color: white, size: 16),
    backgroundColor: rabbit,
  );

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
            height: 35,
            controller: becomeDriverController.driverNameController,
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
          _buildGender,
          _buildBirthYear,
        ],
      ),
    );
  }
  Widget get _buildGender {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          isTitle: true,
          text: 'Gender:',
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => _buildRadioButton(0, 'Male')),
            const Space(width: 10),
            Obx(() => _buildRadioButton(1, 'Female')),
          ],
        ),
      ],
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
  Widget get _buildBirthYear {
    return Column(
      children: [
        const TextWidget(
          isTitle: true,
          text: 'Birth Year:',
        ),
        InkWell(
          onTap: () => showCalender(Get.context!),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(() {
              var isHasData = false.obs;
              if (becomeDriverController.dataDatePicker.value == '') {
                isHasData.value = false;
              }
              else {
                isHasData.value = true;
              }
              return isHasData.value == false ? const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: IconWidget(icon: Icons.calendar_today, size: 20)) : TextWidget(text: becomeDriverController.dataDatePicker.value, size: 14);
            }),
          ),
        ),
      ],
    );
  }
  void showCalender(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
    ).then((DateTime? value) {
      if (value != null) {
        DateTime _fromDate = DateTime.now();
        _fromDate = value;
        var outputFormat = DateFormat('dd-MMM-yy');
        final String date = outputFormat.format(_fromDate);
        becomeDriverController.dataDatePicker.value = date;
      }
    });
  }

  Widget get _buildIdCard{
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            isTitle: true,
            text: 'ID Card:',
          ),
          TextFieldWidget(
            controller: becomeDriverController.idCardController,
            height: 35,
            inputType: TextInputType.phone,
            hintText: 'Enter your ID card',
            hintColor: silver,
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
            inputType: TextInputType.phone,
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
  Widget get _buildDriverAddress{
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            isTitle: true,
            text: 'Where do you live?',
          ),
          const Space(height: 10),
          _buildAddressTextField(
            controller: becomeDriverController.districtController,
            labelText: 'District',
            hintText: 'Select District',
            menuItem: menuDistrictItems,
            noItemFoundText: 'No district matched.',
          ),
          _buildAddressTextField(
            controller: becomeDriverController.communeController,
            labelText: 'Commune',
            hintText: 'Select Commune',
            menuItem: menuCommuneItems,
            noItemFoundText: 'No commune matched.',
          ),
        ],
      ),
    );
  }
  Widget get _buildDriverSchedule{
    return Container(
      margin: const EdgeInsets.only(top: 5),
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
              Obx(
                () => _buildButtonSchedule(
                  0,
                  'Morning',
                  becomeDriverController.morningTextScheduleColor.value,
                  becomeDriverController.morningBackgroundScheduleColor.value,
                  becomeDriverController.morningBorderScheduleColor.value,
                ),
              ),
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
  Widget get _buildDriverReferral{
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TextWidget(
          isTitle: true,
          text: 'Referral code if have:',
        ),
        TextFieldWidget(
          controller: becomeDriverController.referralCodeController,
          width: 150,
          height: 35,
          inputType: TextInputType.number,
          textAlign: TextAlign.center,
          hintText: 'Enter code',
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
  Widget get _buildSubmitButton{
    return Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20),
      child:  ButtonWidget(
        onPressed: () => becomeDriverController.submitData(),
        child: const TextWidget(
          text: 'Submit',
          color: white,
          size: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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
  Widget _buildAddressTextField({required TextEditingController controller, required List<String> menuItem, required String labelText, required String hintText, required String noItemFoundText}){
    return Container(
      color: white,
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: TypeAheadFormField(
        autoFlipDirection: true,
        getImmediateSuggestions: true,
        hideSuggestionsOnKeyboardHide: false,
        hideOnEmpty: false,
        suggestionsCallback: (pattern) => menuItem.where((item) => item.toLowerCase().contains(pattern.toLowerCase())),
        suggestionsBoxDecoration: const SuggestionsBoxDecoration(
          color: white,
          clipBehavior: Clip.hardEdge,
        ),
        itemBuilder: (_, String item) => Container(
          padding: const EdgeInsets.all(10),
          child: TextWidget(
            text: item,
          ),
        ),
        errorBuilder: (context, error) => Text('error',
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
        onSuggestionSelected: (String val) => controller.text = val,
        noItemsFoundBuilder: (context) => Container(
          padding: const EdgeInsets.all(10),
          child: TextWidget(
            text: noItemFoundText,
            size: 12,
          ),
        ),
        textFieldConfiguration: TextFieldConfiguration(
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: black,
          ),
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: silver,
            ),
            contentPadding: const EdgeInsets.only(left: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(),
            ),
          ),
        ),
      ),
    );
  }
}
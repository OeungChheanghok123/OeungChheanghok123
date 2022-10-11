import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class BecomeDriverController extends GetxController {
  final driverNameController = TextEditingController();
  final idCardController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final districtController = TextEditingController();
  final communeController = TextEditingController();
  final referralCodeController = TextEditingController();

  var id = ''.obs;
  var currentDate = ''.obs;
  var dataDatePicker = ''.obs;

  var gender = ''.obs;
  var radioGenderValue = 0.obs;

  var dropDownDistrictValue = "".obs;
  var dropDownCommuneValue = "".obs;

  var vehicle = ''.obs;
  var isSelectedBike = false.obs;
  var isSelectedMotor = false.obs;
  var isSelectedRickshaw = false.obs;

  var shift = [];
  var isSelectMorning = false.obs;
  var isSelectAfternoon = false.obs;
  var isSelectEvening = false.obs;

  var bikeBorderVehicleColor = platinum.obs;
  var bikeBackgroundVehicleColor = white.obs;
  var motorBorderVehicleMotorColor = platinum.obs;
  var motorBackgroundVehicleBikeColor = white.obs;
  var rickshawBorderVehicleBikeColor = platinum.obs;
  var rickshawBackgroundVehicleBikeColor = white.obs;

  var morningTextScheduleColor  = black.obs;
  var morningBorderScheduleColor = silver.obs;
  var morningBackgroundScheduleColor = white.obs;
  var afternoonTextScheduleColor  = black.obs;
  var afternoonBorderScheduleColor = silver.obs;
  var afternoonBackgroundScheduleColor = white.obs;
  var eveningTextScheduleColor  = black.obs;
  var eveningBorderScheduleColor = silver.obs;
  var eveningBackgroundScheduleColor = white.obs;

  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);

  void selectGender(int index) {
    radioGenderValue.value = index;
    if (radioGenderValue.value == 0) {
      gender.value = 'Male';
      debugPrint('Gender: ${gender.value}');
    } else {
      gender.value = 'Female';
      debugPrint('Gender: ${gender.value}');

    }
  }
  void selectVehicle(int index) {
    if (index == 0){
      isSelectedBike.value = true;
      isSelectedMotor.value = false;
      isSelectedRickshaw.value = false;
      vehicle.value = "Bike";
    }
    if (index == 1) {
      isSelectedMotor.value = true;
      isSelectedBike.value = false;
      isSelectedRickshaw.value = false;
      vehicle.value = "Motor";
    }
    if (index == 2) {
      isSelectedRickshaw.value = true;
      isSelectedBike.value = false;
      isSelectedMotor.value = false;
      vehicle.value = "Rickshaw";
    }

    if (isSelectedBike.value  == true){
      bikeBorderVehicleColor.value = rabbit;
      bikeBackgroundVehicleColor.value = rabbit;
    } else {
      bikeBorderVehicleColor.value = platinum;
      bikeBackgroundVehicleColor.value = white;
    }
    if (isSelectedMotor.value == true){
      motorBorderVehicleMotorColor.value = rabbit;
      motorBackgroundVehicleBikeColor.value = rabbit;
    } else {
      motorBorderVehicleMotorColor.value = platinum;
      motorBackgroundVehicleBikeColor.value = white;
    }
    if (isSelectedRickshaw.value  == true){
      rickshawBorderVehicleBikeColor.value = rabbit;
      rickshawBackgroundVehicleBikeColor.value = rabbit;
    } else {
      rickshawBorderVehicleBikeColor.value = platinum;
      rickshawBackgroundVehicleBikeColor.value = white;
    }
  }
  void selectSchedule(int index) {
    if (index == 0) {
      isSelectMorning.value = !isSelectMorning.value;
    }
    if (index == 1) {
      isSelectAfternoon.value = !isSelectAfternoon.value;
    }
    if(index == 2) {
      isSelectEvening.value = !isSelectEvening.value;
    }

    if (isSelectMorning.value  == true){
      morningTextScheduleColor.value = white;
      morningBackgroundScheduleColor.value = rabbit;
      morningBorderScheduleColor.value = none;
      shift.add("Morning");
    } else {
      morningTextScheduleColor.value = black;
      morningBackgroundScheduleColor.value = white;
      morningBorderScheduleColor.value = silver;
    }
    if (isSelectAfternoon.value == true){
      afternoonTextScheduleColor.value = white;
      afternoonBackgroundScheduleColor.value = rabbit;
      afternoonBorderScheduleColor.value = none;
      shift.add("Afternoon");
    } else {
      afternoonTextScheduleColor.value = black;
      afternoonBackgroundScheduleColor.value = white;
      afternoonBorderScheduleColor.value = silver;
    }
    if (isSelectEvening.value  == true){
      eveningTextScheduleColor.value = white;
      eveningBackgroundScheduleColor.value = rabbit;
      eveningBorderScheduleColor.value = none;
      shift.add("Evening");
    } else {
      eveningTextScheduleColor.value = black;
      eveningBackgroundScheduleColor.value = white;
      eveningBorderScheduleColor.value = silver;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentDate();
    getLastDriverID();
    selectGender(0);
  }

  void getLastDriverID() {
    var listDriverID = [];
    driverCollection.orderBy(DriverModel.driverIdString).get().then((value) {
      for (var data in value.docs) {
        listDriverID.add(data[DriverModel.driverIdString]);
        var num = listDriverID.length;
        id.value = (num + 1).toString();
      }
    });
  }
  void getCurrentDate() {
    var today = DateTime.now();
    var format = DateFormat('dd-MMM-yy');
    var output = format.format(today);
    currentDate.value = output;
  }
  void submitData() {
    var tempPhone = phoneNumberController.text;
    if (phoneNumberController.text != "") {
      List phone = phoneNumberController.text.split("");
      if (phone[0] == "0") {
        phone.removeAt(0);
      }

      phoneNumberController.text = phone.join();
    }

    if (phoneNumberController.text == "" || phoneNumberController.text.length < 8) {
      Get.defaultDialog(
        radius: 5,
        title: 'Error',
        barrierDismissible: false,
        titleStyle: const TextStyle(fontSize: 16, color: red),
        titlePadding: const EdgeInsets.only(top: 10),
        contentPadding: const EdgeInsets.only(top: 15, bottom: 20),
        middleTextStyle: const TextStyle(fontSize: 14),
        middleText: 'Your phone number is not correctly!!!\n',
        textConfirm: 'Got it',
        confirmTextColor: white,
        buttonColor: rabbit,
        onConfirm: () => Get.back(),
      );
      phoneNumberController.text = tempPhone;
    }
    else {
      var temp = shift.toSet().toList();
      driverCollection.where(DriverModel.telString, isEqualTo: phoneNumberController.text).get().then((data){
        if (data.docs.isEmpty) {
          driverCollection.add({
            DriverModel.driverNameString: driverNameController.text,
            DriverModel.genderString: gender.value,
            DriverModel.yobString: dataDatePicker.value,
            DriverModel.idCardString: idCardController.text,
            DriverModel.telString: phoneNumberController.text,
            DriverModel.vehicleString: vehicle.value,
            DriverModel.locationString: {'district': districtController.text, 'commune': communeController.text},
            DriverModel.shiftString: temp,
            DriverModel.referralCodeString: referralCodeController.text,
            DriverModel.createAtString: currentDate.value,
            DriverModel.imageString: 'assets/image/driver_profile.png',
            DriverModel.isOnlineString: false,
            DriverModel.statusString: '',
            DriverModel.driverIdString: id.value,
          });
          Get.offAllNamed('/become_driver_success');
        }
        else {
          Get.offAllNamed('/become_driver_fail');
        }
      });
    }
  }
}
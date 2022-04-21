import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/become_driver_controller.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class EditProfileController extends GetxController{
  var becomeDriverController = BecomeDriverController();
  var driverNameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var title = "Edit Profile";
  var hintPhoneNumber = "098 496 050".obs;

  var isSelectedBike = false.obs; var isSelectedMotor = false.obs; var isSelectedRickshaw = false.obs;

  var bikeBorderVehicleColor = platinum.obs; var bikeBackgroundVehicleColor = white.obs;
  var motorBorderVehicleMotorColor = platinum.obs; var motorBackgroundVehicleBikeColor = white.obs;
  var rickshawBorderVehicleBikeColor = platinum.obs; var rickshawBackgroundVehicleBikeColor = white.obs;

  var morningTextScheduleColor  = black.obs; var morningBorderScheduleColor = silver.obs; var morningBackgroundScheduleColor = white.obs;
  var afternoonTextScheduleColor  = black.obs; var afternoonBorderScheduleColor = silver.obs; var afternoonBackgroundScheduleColor = white.obs;
  var eveningTextScheduleColor  = black.obs; var eveningBorderScheduleColor = silver.obs; var eveningBackgroundScheduleColor = white.obs;

  var isMon = false.obs; var isTue = false.obs; var isWed = false.obs; var isThu = false.obs; var isFri = false.obs; var isSat = false.obs; var isSun = false.obs;

  var monTextColor = black.obs; var monBackColor = platinum.obs;
  var tueTextColor = black.obs; var tueBackColor = platinum.obs;
  var wedTextColor = black.obs; var wedBackColor = platinum.obs;
  var thuTextColor = black.obs; var thuBackColor = platinum.obs;
  var friTextColor = black.obs; var friBackColor = platinum.obs;
  var satTextColor = black.obs; var satBackColor = platinum.obs;
  var sunTextColor = black.obs; var sunBackColor = platinum.obs;

  @override
  onInit() {
    super.onInit();
    setColorScheduleTime();
  }
  void selectVehicle(int index) {
    if (index == 0){
      isSelectedBike.value = true;
      isSelectedMotor.value = false;
      isSelectedRickshaw.value = false;
    }
    if (index == 1) {
      isSelectedMotor.value = true;
      isSelectedBike.value = false;
      isSelectedRickshaw.value = false;
    }
    if (index == 2) {
      isSelectedRickshaw.value = true;
      isSelectedBike.value = false;
      isSelectedMotor.value = false;
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
  void selectScheduleTime(int index) {
    if (index == 0) {
      becomeDriverController.isSelectMorning.value = !becomeDriverController.isSelectMorning.value;
    }
    if (index == 1) {
      becomeDriverController.isSelectAfternoon.value = !becomeDriverController.isSelectAfternoon.value;
    }
    if(index == 2) {
      becomeDriverController.isSelectEvening.value = !becomeDriverController.isSelectEvening.value;
    }

    setColorScheduleTime();
  }
  void selectScheduleWeek(int index) {
    switch(index) {
      case 0:
        isMon.value = !isMon.value;
        break;
      case 1:
        isTue.value = !isTue.value ;
        break;
      case 2:
        isWed.value  = !isWed.value ;
        break;
      case 3:
        isThu.value  = !isThu.value ;
        break;
      case 4:
        isFri.value  = !isFri.value ;
        break;
      case 5:
        isSat.value  = !isSat.value ;
        break;
      case 6:
        isSun.value  = !isSun.value ;
        break;
    }

    if (isMon.value == true){
      monTextColor.value = white;
      monBackColor.value = rabbit;
    }
    else {
      monTextColor.value = black;
      monBackColor.value = platinum;
    }
    if (isTue.value == true){
      tueTextColor.value = white;
      tueBackColor.value = rabbit;
    }
    else {
      tueTextColor.value = black;
      tueBackColor.value = platinum;
    }
    if (isWed.value == true){
      wedTextColor.value = white;
      wedBackColor.value = rabbit;
    }
    else {
      wedTextColor.value = black;
      wedBackColor.value = platinum;
    }
    if (isThu.value == true){
      thuTextColor.value = white;
      thuBackColor.value = rabbit;
    }
    else {
      thuTextColor.value = black;
      thuBackColor.value = platinum;
    }
    if (isFri.value == true){
      friTextColor.value = white;
      friBackColor.value = rabbit;
    }
    else {
      friTextColor.value = black;
      friBackColor.value = platinum;
    }
    if (isSat.value == true){
      satTextColor.value = white;
      satBackColor.value = rabbit;
    }
    else {
      satTextColor.value = black;
      satBackColor.value = platinum;
    }
    if (isSun.value == true){
      sunTextColor.value = white;
      sunBackColor.value = rabbit;
    }
    else {
      sunTextColor.value = black;
      sunBackColor.value = platinum;
    }
  }
  void setColorScheduleTime() {
    if (becomeDriverController.isSelectMorning.value  == true){
      morningTextScheduleColor.value = white;
      morningBackgroundScheduleColor.value = rabbit;
      morningBorderScheduleColor.value = none;
    } else {
      morningTextScheduleColor.value = black;
      morningBackgroundScheduleColor.value = white;
      morningBorderScheduleColor.value = silver;
    }
    if (becomeDriverController.isSelectAfternoon.value == true){
      afternoonTextScheduleColor.value = white;
      afternoonBackgroundScheduleColor.value = rabbit;
      afternoonBorderScheduleColor.value = none;
    } else {
      afternoonTextScheduleColor.value = black;
      afternoonBackgroundScheduleColor.value = white;
      afternoonBorderScheduleColor.value = silver;
    }
    if (becomeDriverController.isSelectEvening.value  == true){
      eveningTextScheduleColor.value = white;
      eveningBackgroundScheduleColor.value = rabbit;
      eveningBorderScheduleColor.value = none;
    } else {
      eveningTextScheduleColor.value = black;
      eveningBackgroundScheduleColor.value = white;
      eveningBorderScheduleColor.value = silver;
    }
  }
}
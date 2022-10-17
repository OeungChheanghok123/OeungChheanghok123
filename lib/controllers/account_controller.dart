import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:loy_eat/controllers/languages_controller.dart';
import 'package:loy_eat/controllers/main_page_controller.dart';
import 'package:loy_eat/models/driver_model.dart';
import 'package:loy_eat/models/remote_data.dart';
import 'package:loy_eat/screens/start_up_screen.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class AccountController extends GetxController {
  var phoneNumber = ''.obs;
  var id = '';
  var docId = '';
  var defaultLanguage = ''.obs;
  final _changeLanguage = ''.obs;

  var khmerImage = 'assets/image/cambodia_flag.svg'.obs;
  var ukImage = 'assets/image/uk_flag.svg'.obs;
  var khmerLabel = 'ភាសាខ្មែរ'.obs;
  var ukLabel = 'English'.obs;

  var isSelectedKhmer = false.obs;
  var isSelectedEnglish = true.obs;
  var radioColorKhmer = white.obs;
  var radioColorEnglish = rabbit.obs;

  final languagesController = Get.put(LanguagesController());
  final mainPageController = Get.put(MainPageController());

  final driverCollection = FirebaseFirestore.instance.collection(DriverModel.collectionName);

  final _driverData = RemoteData<List<DriverModel>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List<DriverModel>> get driverData => _driverData.value;

  @override
  void onInit() {
    _changeLanguage.value = mainPageController.readLanguage();
    defaultLanguage.value = _changeLanguage.value;
    _loadDriverData();
    super.onInit();
  }
  void onConfirmSelectingLanguage(int index) {
    if (index == 1) {
      isSelectedKhmer.value = true;
      isSelectedEnglish.value = false;
    } else {
      isSelectedEnglish.value = true;
      isSelectedKhmer.value = false;
    }

    if (isSelectedKhmer.value == true) {
      radioColorKhmer.value = rabbit;
      radioColorEnglish.value = white;
      _changeLanguage.value = khmerImage.value;

      languagesController.changeLanguage('kh', 'KH');
      mainPageController.writeLanguage(khmerImage.value);
      mainPageController.writeLanguageCode('kh');
      mainPageController.writeCountryCode('KH');

    } else {
      radioColorKhmer.value = white;
      radioColorEnglish.value = rabbit;
      _changeLanguage.value = ukImage.value;

      languagesController.changeLanguage('en', 'US');
      mainPageController.writeLanguage(ukImage.value);
      mainPageController.writeLanguageCode('en');
      mainPageController.writeCountryCode('US');
    }
    mainPageController.writeLogin(true);
    defaultLanguage.value = _changeLanguage.value;
  }
  void _loadDriverData() {
    try {
      phoneNumber.value = mainPageController.readDriverPhoneNumber();
      final data = driverCollection.where(DriverModel.telString, isEqualTo: phoneNumber.value).snapshots();
      data.listen((result) {
        if (result.docs.isNotEmpty) {
          final driver = result.docs.map((e) => DriverModel.fromMap(e.data())).toList();
          _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.success, data: driver);

          id = driver[0].driverId;
          loadDocumentId(id);
        }
      });
    } catch (ex) {
      _driverData.value = RemoteData<List<DriverModel>>(status: RemoteDataStatus.error, data: null);
    }
  }
  void loadDocumentId(String id) {
    driverCollection.where(DriverModel.driverIdString, isEqualTo: id).get().then((snapshot) => {
      snapshot.docs.forEach((element) {      // ignore: avoid_function_literals_in_foreach_calls
        docId = element.id;
      }),
    });
  }
  void logout(BuildContext context) {
    mainPageController.removeLogin();
    mainPageController.removeDriverPhoneNumber();
    mainPageController.removeLanguage();
    mainPageController.removeCode();
    driverCollection.doc(docId).update({DriverModel.isOnlineString : false}).then((_) => debugPrint('Driver is Offline'));
    _signOut();
    Phoenix.rebirth(context);
  }

  Future<StartUpScreen> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return StartUpScreen();
  }
}
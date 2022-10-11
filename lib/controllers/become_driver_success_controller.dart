import 'dart:async';

import 'package:get/get.dart';

class BecomeDriverSuccessController extends GetxController {
  Timer? _timer;
  var startCounter = 5.obs;
  var showButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (startCounter.value == 0) {
        timer.cancel();
        showButton.value = true;
      }
      else {
        startCounter--;
      }
    },
    );
  }
  void closeTimer() {
    _timer!.cancel();
  }
}
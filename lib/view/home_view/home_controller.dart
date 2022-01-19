import 'dart:developer';

import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GuestHomeController extends GetxController {

  void onTimeTrialModeTapped() {
    Get.toNamed('/GuestTtmMatch');
  }

  void onVsModeTapped(AuthState state) async {
    googleSignIn();
    if (state != AuthState.anonymous) {
      Get.toNamed('/Home');
    }
  }

  void googleSignIn() async {
    logger.i('called');
    // isSignIn = true;
    await authController
        .upgradeAnonymousToGoogle()
        .then((value) {
      log('googleSignIn()-> returned value is $value');
      // log('googleSignIn()-> user upgraded...current user Id is ${value.uid} connected with ${value.providerData[0].providerId}');
      // admissionLogic.authUser = value;
      // Get.toNamed('/Home');
    });
    // isSignIn = false;
  }

  void onQuitPressed() {
    SystemNavigator.pop();
  }
}

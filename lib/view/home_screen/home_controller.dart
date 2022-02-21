import 'dart:developer';

import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  @override
  void onInit() {
    if (Get.isRegistered<MatrixEffectController>()) Get.delete<MatrixEffectController>();
    super.onInit();
  }

  void onAvatarTapped() {

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


}

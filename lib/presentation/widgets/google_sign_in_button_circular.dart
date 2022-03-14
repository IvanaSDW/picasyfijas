import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class GoogleSignInButtonCircular extends GetWidget<AuthController> {
  final logger = Logger();

  GoogleSignInButtonCircular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: appController.isBusy
          ? const CircularProgressIndicator()
          : InkWell(
              onTap: () async =>
                  await controller.upgradeAnonymousToGoogle(),
              child: Get.locale.toString().substring(0, 2) == 'es'
                  ? Image.asset('assets/images/google_button_circular_spanish.png')
                  : Image.asset('assets/images/google_button_circular.png')
            ),
    );
  }
}
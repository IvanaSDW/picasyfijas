import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../constants.dart';

class GoogleSignInButtonSquared extends GetWidget<AuthController> {
  const GoogleSignInButtonSquared({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: appController.isBusy
          ? SpinKitChasingDots()
          : InkWell(
              onTap: () async => authController.authState == AuthState.signedOut
                  ? await controller.signInWithGoogle()
                  : await controller.upgradeAnonymousToGoogle(),
              child: const Image(
                image: AssetImage(
                  'assets/images/google_button.png',
                ),
              ),
            ),
    );
  }
}

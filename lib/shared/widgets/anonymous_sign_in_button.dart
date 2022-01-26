import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/controllers/auth_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AnonymousSignInButton extends GetWidget<AuthController> {
  const AnonymousSignInButton({Key? key}) : super(key: key);


  void onTapAction() {
    appController.isBusy = true;
    controller.signInAnonymously();
    appController.isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTapAction,
        child: Obx(() {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: 150,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText('play_as_guest'.tr,
                        textAlign: TextAlign.center,
                        style: textButtonStyle,
                      ),
                      AutoSizeText('basic_features'.tr,
                        textAlign: TextAlign.center,
                        style: textButtonStyle,
                        maxFontSize: 12,
                      ),
                    ],
                  )
              ),
              appController.isBusy ? const SpinKitSpinningLines(color: Colors.white) : Container()
            ],
          );
        }),
      ),
    );
  }

}
import 'package:bulls_n_cows_reloaded/presentation/widgets/anonymous_sign_in_button.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/google_sign_in_button.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingUnsignedScreen extends StatelessWidget {
  const LandingUnsignedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: showMatrix(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? MatrixEffect(
              controller: Get.put(MatrixEffectController(), tag: 'landing'))
              : Obx(() {
            return AbsorbPointer(
              absorbing: appController.isBusy,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/panel_logo_eng.png'),
                  const GoogleSignInButtonSquared(),
                  const AnonymousSignInButton(),
                ],
              ),
            );
          });
        }
    );
  }

  Future showMatrix() async {
    await Future.delayed(const Duration(seconds: 3))
        .then((value) => Get.delete<MatrixEffectController>(tag: 'landing'));
  }
}

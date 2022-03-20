import 'package:bulls_n_cows_reloaded/main.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/splash_screen/logo_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/splash_screen/splash_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presentation/widgets/matrix_effect/matrix_effect.dart';


class SplashWidget extends StatelessWidget {
  // final AsyncSnapshot snapshot;
  final SplashController controller = Get.put(SplashController());

  SplashWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, snapshot) {
        logger.i(
            'AsyncSnapshot state: ${snapshot.connectionState}, Current route: ${Get
                .currentRoute}');
        return snapshot.connectionState == ConnectionState.waiting
          ? Container(color: Colors.transparent,)
          : Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 2500),
                      child: controller.showLogo.value ? SizedBox(
                          width: Get.width * 0.7,
                          child: const LogoWidget()
                      )
                      : const SizedBox.shrink(),
                    );
                  }),
                  Obx(() {
                    return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 4000),
                        child: controller.hideBackground.value ?
                        const SizedBox.shrink()
                        : MatrixEffect(
                          key: const ValueKey(2),
                          controller: Get.put(
                              MatrixEffectController(speedMillis: 100),
                              tag: 'splash'),
                        )
                    );
                  }),
                ],
              )
          );
      }
    );
  }
}
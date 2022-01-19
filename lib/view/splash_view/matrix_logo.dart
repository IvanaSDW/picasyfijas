
import 'dart:ui';

import 'package:bulls_n_cows_reloaded/view/splash_view/matrix_effect.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/splash_controller.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/start_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatrixLogo extends StatelessWidget {
  MatrixLogo({Key? key}) : super(key: key);
  final SplashController controller = Get.put(SplashController());


  @override
  Widget build(BuildContext context) {
    return Obx(()=> Stack(
      children: [
        Hero(
            tag: 'matrix',
            child: MatrixEffect()
        ),
        Column(
          children: [
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 3),
                curve: Curves.easeInCirc,
                onEnd: () => controller.startButtonVisible.value = true,
                builder: (BuildContext context, double opacity, Widget? child) {
                  return Opacity(opacity: opacity,
                    child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10, sigmaX: 10
                          ),
                          child: Hero(
                            tag: 'logo',
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Get.locale.toString().substring(0,2) == 'es'
                                  ? Image.asset('assets/images/logo_spanish.png')
                              : Image.asset('assets/images/logo_english.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
            Visibility(
              visible: controller.startButtonVisible.value,
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeInCirc,
                  builder: (BuildContext context, double opacity, Widget? child) {
                    return Opacity(opacity: opacity,
                      child: Center(
                        child: StartButton(onTapAction: () {},)
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ],
    ),
    );
  }
}
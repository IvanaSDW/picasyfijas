import 'package:bulls_n_cows_reloaded/presentation/pages/splash_screen/logo_clipper_eng.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants.dart';
import '../../widgets/matrix_effect/matrix_effect.dart';
import '../../widgets/matrix_effect/matrix_effect_controller.dart';
import 'logo_clipper_spa.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ClipPath(
        clipper: Get.locale.toString().substring(0, 2) == 'es'
            ? LogoClipperSpa() : LogoClipperEng(),
        child: AspectRatio(
          aspectRatio: appController.locale.toString().substring(0, 2) == 'es' ? 1.95 : 2.18,
          child: MatrixEffect(
              key: const ValueKey(1),
              controller: Get.put(MatrixEffectController(
                  speedMillis: 50,
                  colors: [
                    // Colors.transparent,
                    const Color(0x2022FF00),
                    // originalColors.accentColor2!,
                    const Color(0xAC41BB3D),
                    Colors.green,
                    Colors.white
                  ]),
                tag: 'logo',
              )
          ),
        ),
      );
  }
}

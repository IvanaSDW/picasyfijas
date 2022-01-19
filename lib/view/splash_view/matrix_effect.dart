import 'package:bulls_n_cows_reloaded/view/splash_view/matrix_effect_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatrixEffect extends StatelessWidget {
  MatrixEffect({Key? key}) : super(key: key);
  final MatrixEffectController controller = Get.put(MatrixEffectController());


  @override
  Widget build(BuildContext context) {
    controller.startTimer();
    return Obx(() {
      return Stack(
        children: controller.verticalLines,
      );
    });
  }
}
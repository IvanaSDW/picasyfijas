import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatrixEffect extends StatelessWidget {
  const MatrixEffect({Key? key, required this.controller}) : super(key: key);
  final MatrixEffectController controller;

  @override
  Widget build(BuildContext context) {
    controller.startTimer();
    return
      Obx(() {
        return Stack(
          children: controller.verticalLines.value,
        );
      });
  }
}
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/numeric_keyboard/numeric_keyboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme.dart';

class InputSecretNumberWidget extends StatelessWidget {
  const InputSecretNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width*0.7,
      child: Column(
        children: [
          const Text(
              'Enter your secret number:'
          ),
          const NumericKeyboardWidget(),
          Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  minHeight: 40,
                  backgroundColor: originalColors.playerOneBackground,
                  color: originalColors.playerTwoBackground,
                  value: Get.find<VersusGameLogic>().progressValue.value / 10000,
                ),
                InkWell(
                  child: const Text(
                    'Auto generate number ->', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colors.black87),
                  ),
                  onTap: () => Get.find<VersusGameLogic>().onAutoGenerateSecretNumber(),
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}

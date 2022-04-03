import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/numeric_keyboard/numeric_keyboard_view.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
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
          const SizedBox(
            height: 20,
          ),
          Text(
            'enter_your_secret_number:'.tr,
            style: defaultTextStyle,
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
                  child: AutoSizeText(
                    'auto_generate_number'.tr, textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
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

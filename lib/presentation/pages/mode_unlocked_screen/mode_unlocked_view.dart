import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/mode_unlocked_screen/mode_unlocked_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/continue_button.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeUnlockedView extends StatelessWidget {
  ModeUnlockedView({Key? key}) : super(key: key);
  final ModeUnlockedController controller = Get.put(ModeUnlockedController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mode_unlocked_grid.png'),
              fit: BoxFit.contain,
            )
        ),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: false,
                onFinished: () => controller.showUnlockedWithEffect(),
                animatedTexts: [
                  TyperAnimatedText(
                    'vs_mode'.tr,
                    speed: const Duration(milliseconds: 150),
                    textStyle: TextStyle(
                        fontSize: 40,
                        color: originalColors.mainTitleColor,
                        fontFamily: 'Digital'
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              AnimatedOpacity(
                opacity: controller.showUnlocked ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.bounceIn,
                onEnd: () => Future.delayed(const Duration(milliseconds: 1000), () => controller.showLittleText1WithEffect()),
                child: AutoSizeText('unlocked'.tr,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 80,
                      color: originalColors.accentColor2,
                      fontFamily: 'Digital'
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              Visibility(
                visible: controller.showLittleText1,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  onFinished: () => Future.delayed(const Duration(milliseconds: 300), () => controller.showLittleText2WithEffect()),
                  animatedTexts: [
                    TyperAnimatedText('enjoy_playing_vs_mode_line1'.tr,
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: originalColors.keyOnColor,
                          fontFamily: 'Digital'
                      ),
                      speed: const Duration(milliseconds: 91),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              Visibility(
                visible: controller.showLittleText2,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  onFinished: () => controller.showButtonContinue = true,
                  animatedTexts: [
                    TyperAnimatedText('enjoy_playing_vs_mode_line2'.tr,
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: originalColors.keyOnColor,
                          fontFamily: 'Digital'
                      ),
                      speed: const Duration(milliseconds: 111)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80,),
              AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: controller.showButtonContinue ? 1.0 : 0.0,
                  child: ContinueButton(onTapAction: () => controller.onContinueTapped()))
            ],
          );
        }),
      ),
    );
  }
}

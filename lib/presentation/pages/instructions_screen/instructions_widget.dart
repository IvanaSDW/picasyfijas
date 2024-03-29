import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/continue_button.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/instructions_screen/instructions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme.dart';

class InstructionsWidget extends StatelessWidget {

  final VoidCallback onContinueTappedAction;
  final InstructionsController controller = Get.put(InstructionsController());

  InstructionsWidget({Key? key, required this.onContinueTappedAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: originalColors.backgroundColor,
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 10,
              child: Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(
                        'assets/images/instructions_header.png'),
                        fit: BoxFit.fitWidth),
                  ),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'instructions'.tr,
                          textStyle: reverseTitleTextStyle,
                          speed: const Duration(milliseconds: 90),
                        )
                      ],
                      isRepeatingAnimation: false,
                      onFinished: () {
                        controller.instructionsTextVisible = true;
                      },
                    ),
                  )
              ),
            ),
            Expanded(flex: 18,
              child: Center(
                child: Visibility(
                  visible: controller.instructionsTextVisible,
                  child: SizedBox(
                      width: Get.width - 48.0,
                      child: DefaultTextStyle(
                        style: defaultTextStyle,
                        child: AnimatedTextKit(animatedTexts: [
                          TyperAnimatedText(
                            'instructions_detail_1'.tr,
                            textAlign: TextAlign.start,
                            speed: const Duration(milliseconds: 80),
                          ),
                          TyperAnimatedText(
                              'instructions_detail_2'.tr,
                              speed: const Duration(milliseconds: 80)
                          ),
                          TyperAnimatedText(
                              'instructions_detail_3'.tr,
                              speed: const Duration(milliseconds: 80)
                          ),
                          TyperAnimatedText(
                              'instructions_detail_4'.tr,
                              textAlign: TextAlign.start,
                              speed: const Duration(milliseconds: 80)
                          ),
                          TyperAnimatedText(
                              'instructions_detail_5'.tr,
                              speed: const Duration(milliseconds: 80)
                          ),
                          TyperAnimatedText(
                              'instructions_detail_6'.tr,
                              speed: const Duration(milliseconds: 80)
                          ),
                        ],
                          onNextBeforePause: (index, isLast) {
                            switch (index) {
                              case 0:
                                controller.exampleTitleVisible = true;
                                break;
                              case 1:
                                controller.example3Visible = true;
                                break;
                              case 2:
                                controller.example5Visible = true;
                                break;
                              case 3:
                                controller.example6Visible = true;
                                break;
                              case 4:
                                controller.example7Visible = true;
                                break;
                            }
                          },
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 5000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                          // child: AutoSizeText('instructions_detail'.tr, style: defaultTextStyle,)))
                        ),
                      )),
                ),
              ),
            ),
            Expanded(flex: 52,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  decoration: controller.exampleTitleVisible ?
                  const BoxDecoration(
                      image: DecorationImage(image: AssetImage(
                          'assets/images/brackets_red_grid.png'),
                          fit: BoxFit.fill)
                  )
                      : null ,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 4,),
                        Expanded(flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Visibility(visible: controller
                                .exampleTitleVisible,
                                child: SizedBox(width: Get.width,
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TyperAnimatedText(
                                          'example'.tr,
                                          textStyle: titleTextStyle,
                                          speed: const Duration(
                                              milliseconds: 50),
                                        ),
                                      ],
                                      isRepeatingAnimation: false,
                                      onFinished: () {
                                        controller.example1Visible =
                                        true;
                                      },
                                    )
                                )
                            ),
                          ),
                        ),
                        Expanded(flex: 7,
                          child: Visibility(
                            visible: controller.example1Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'lets say..'.tr,
                                    textStyle: defaultTextStyle,
                                    speed: const Duration(
                                        milliseconds: 40),
                                  )
                                ],
                                isRepeatingAnimation: false,
                                onFinished: () {
                                  controller.example2Visible = true;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 13,
                          child: Visibility(
                            child: AnimatedTextKit(
                              animatedTexts: [
                                WavyAnimatedText(
                                  '4 2 7 5',
                                  textStyle: exampleSecretNumberStyle,
                                )
                              ],
                              totalRepeatCount: 1,
                            ),
                            visible: controller.example2Visible,
                          ),
                        ),
                        Expanded(flex: 7,
                          child: Visibility(
                            visible: controller.example3Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'and your guess..'.tr,
                                    textStyle: defaultTextStyle,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                isRepeatingAnimation: false,
                                onFinished: () {
                                  controller.example4Visible = true;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 13,
                          child: Visibility(
                            visible: controller.example4Visible,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                WavyAnimatedText(
                                  '5 2 9 4',
                                  textStyle: exampleGuessNumberStyle,
                                )
                              ],
                              totalRepeatCount: 1,
                            ),
                          ),
                        ),
                        Expanded(flex: 8,
                          child: Visibility(
                            visible: controller.example5Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'the result..'.tr,
                                    textStyle: defaultTextStyle,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                isRepeatingAnimation: false,
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 9,
                          child: Visibility(
                            visible: controller.example6Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'one bull'.tr,
                                    textStyle: exampleNumberStyleSmallLight,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                isRepeatingAnimation: false,
                                onFinished: () async {
                                  await Future.delayed(
                                      const Duration(
                                          milliseconds: 2000));
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 9,
                          child: Visibility(
                            visible: controller.example7Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'two cows'.tr,
                                    textStyle: exampleNumberStyleSmallLight,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                pause: const Duration(
                                    milliseconds: 5000),
                                isRepeatingAnimation: false,
                                onFinished: () async {
                                  // await Future.delayed(const Duration(milliseconds: 2000));
                                  controller.example8Visible = true;
                                },
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 4,),
                        Expanded(flex: 8,
                          child: Visibility(
                            visible: controller.example8Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'and you..'.tr,
                                    textStyle: defaultTextStyle,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                isRepeatingAnimation: false,
                                onFinished: () {
                                  controller.example9Visible = true;
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 12,
                          child: Visibility(
                            visible: controller.example9Visible,
                            child: SizedBox(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    '1B2C'.tr,
                                    textStyle: titleTextStyle,
                                    speed: const Duration(
                                        milliseconds: 50),
                                  )
                                ],
                                isRepeatingAnimation: false,
                                onFinished: () {
                                  controller.continueButtonVisible =
                                  true;
                                },
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                )
            ),
            Expanded(flex: 20,
              child: Center(
                child: controller.continueButtonVisible ?
                ContinueButton(
                  onTapAction: onContinueTappedAction,
                )
                    : InkWell(
                  onTap: onContinueTappedAction,
                  child: Text(
                    'skip'.tr,
                    style: textButtonStyle,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

}
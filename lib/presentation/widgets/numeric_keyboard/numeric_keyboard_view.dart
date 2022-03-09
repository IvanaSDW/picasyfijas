import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/text_styles.dart';
import 'numeric_keyboard_controller.dart';

class NumericKeyboardWidget extends GetWidget<NumericKeyboardController> {
  const NumericKeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF091309),
              border: Border(
                  top: BorderSide(color: Colors.white.withAlpha(200), width: 0.5),
                  left:  BorderSide(color: Colors.white.withOpacity(0.7), width: 0.5),
                  bottom: BorderSide(color: originalColors.keyOffColor!),
                  right: BorderSide(color: originalColors.keyOffColor!)
              ),
            ),
            child: Column(
              children: [
                Expanded(flex: 28,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [originalColors.backPanelColor!, originalColors.keyOffColor!],
                                  begin: Alignment.topCenter, end: Alignment.bottomRight
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: originalColors.screenColor
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(flex: 72,
                    child: Container(
                      color: const Color(0xFF091309),
                    )
                ),
              ],
            ),
          ),
        ),
        Obx(() => AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 25,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 25, child: ScreenDigit(keyIndex: 0, keyEnabled: controller.screenDigitEnabled[0],)),
                        Expanded(flex: 25, child: ScreenDigit(keyIndex: 1, keyEnabled: controller.screenDigitEnabled[1],)),
                        Expanded(flex: 25, child: ScreenDigit(keyIndex: 2, keyEnabled: controller.screenDigitEnabled[2],)),
                        Expanded(flex: 25, child: ScreenDigit(keyIndex: 3, keyEnabled: controller.screenDigitEnabled[3],)),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 25, child: NumberKey(keyNumber: 1, keyEnabled: controller.numberKeyEnabled[1],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 2, keyEnabled: controller.numberKeyEnabled[2],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 3, keyEnabled: controller.numberKeyEnabled[3],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 4, keyEnabled: controller.numberKeyEnabled[4],)),
                    ],
                  ),
                ),
                Expanded(flex: 25,
                  child: Row(
                    children: [
                      Expanded(flex: 25, child: NumberKey(keyNumber: 5, keyEnabled: controller.numberKeyEnabled[5],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 6, keyEnabled: controller.numberKeyEnabled[6],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 7, keyEnabled: controller.numberKeyEnabled[7],)),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 8, keyEnabled: controller.numberKeyEnabled[8],)),
                    ],
                  ),
                ),
                Expanded(flex: 25,
                  child: Row(
                    children: [
                      Expanded(flex: 25, child: NumberKey(keyNumber: 9, keyEnabled: controller.numberKeyEnabled[9], )),
                      Expanded(flex: 25, child: NumberKey(keyNumber: 0, keyEnabled: controller.numberKeyEnabled[0], )),
                      Expanded(flex: 25, child: BackSpaceKey(keyEnabled: controller.bsKeyEnabled.value,)),
                      Expanded(flex: 25, child: EnterKey(keyEnabled: controller.enterKeyEnabled.value,)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }

}

class NumberKey extends StatelessWidget {
  final int keyNumber;
  final bool keyEnabled;
  final NumericKeyboardController keyboard = Get.find();

  NumberKey({Key? key,
    required this.keyNumber, required this.keyEnabled,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? keyboard.numberKeyTapped(keyNumber) : {},
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              keyNumber.toString(),
              textAlign: TextAlign.center,
              style: keyEnabled ? numberKeyOnStyle : numberKeyOffStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenDigit extends StatelessWidget {

  final int keyIndex;
  final bool keyEnabled;
  final NumericKeyboardController keyboard = Get.find();

  ScreenDigit({Key? key,
    required this.keyIndex, required this.keyEnabled,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Center(
          child: AutoSizeText(
            keyboard.screenDigitNumbers[keyIndex].toString(),
            style: keyEnabled ? screenDigitOnStyle : screenDigitOffStyle,
          ),
        ),
    );
  }
}


class EnterKey extends StatelessWidget {

  final bool keyEnabled;
  final NumericKeyboardController keyboard = Get.find();

  EnterKey({Key? key, required this.keyEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? keyboard.onEnterTapped() : {},
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0, right: 6.0, top: 4.0),
        child: Image(
          image: keyEnabled
              ? const AssetImage("assets/images/enter_key_on.png",)
              : const AssetImage("assets/images/enter_key_off.png",),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}


class BackSpaceKey extends StatelessWidget {

  final bool keyEnabled;
  final NumericKeyboardController keyboard = Get.find();

  BackSpaceKey({Key? key, required this.keyEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? keyboard.bsKeyTapped() : {},
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
        child: Image(
          image: keyEnabled
              ? const AssetImage("assets/images/bs_key_on.png")
              : const AssetImage("assets/images/bs_key_off.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

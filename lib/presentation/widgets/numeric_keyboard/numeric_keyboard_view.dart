import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/text_styles.dart';
import '../../controllers/numeric_keyboard_controller.dart';

class NumericKeyboardWidget extends GetWidget<NumericKeyboardController> {
  const NumericKeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const AspectRatio(
          aspectRatio: 1,
          child: Image(
            image: AssetImage("assets/images/keyboard_background.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        Obx(() => AspectRatio(
          aspectRatio: 1,
          child: Column(
            // crossAxisCount: 4,
            children: [
              Expanded(flex: 25,
                child: Row(
                  children: [
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 0, keyEnabled: controller.screenDigitEnabled[0],)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 1, keyEnabled: controller.screenDigitEnabled[1],)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 2, keyEnabled: controller.screenDigitEnabled[2],)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 3, keyEnabled: controller.screenDigitEnabled[3],)),
                  ],
                ),
              ),
              Expanded(flex: 25,
                child: Row(
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
      ],
    );
  }

}

class NumberKey extends StatelessWidget {
  final int keyNumber;
  final bool keyEnabled;

  const NumberKey({Key? key,
    required this.keyNumber, required this.keyEnabled,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? Get.find<NumericKeyboardController>().numberKeyTapped(keyNumber) : {},
      child: Center(
        child: Text(
          keyNumber.toString(),
          style: keyEnabled ? numberKeyOnStyle : numberKeyOffStyle,
        ),
      ),
    );
  }
}

class ScreenDigit extends StatelessWidget {

  final int keyIndex;
  final bool keyEnabled;
  const ScreenDigit({Key? key,
    required this.keyIndex, required this.keyEnabled,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Center(
          child: Text(
            Get.find<NumericKeyboardController>().screenDigitNumbers[keyIndex].toString(),
            style: keyEnabled ? screenDigitOnStyle : screenDigitOffStyle,
          ),
        ),
    );
  }
}


class EnterKey extends StatelessWidget {

  final bool keyEnabled;

  const EnterKey({Key? key, required this.keyEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? Get.find<NumericKeyboardController>().enterKeyTapped() : {},
      child: Center(
        child: Image(
          image: keyEnabled
              ? const AssetImage("assets/images/enter_key_on.png")
              : const AssetImage("assets/images/enter_key_off.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}


class BackSpaceKey extends StatelessWidget {

  final bool keyEnabled;

  const BackSpaceKey({Key? key, required this.keyEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? Get.find<NumericKeyboardController>().bsKeyTapped() : {},
      child: Center(
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

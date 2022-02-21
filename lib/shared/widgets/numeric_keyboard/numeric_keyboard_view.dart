import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../text_styles.dart';
import 'numeric_keyboard_logic.dart';

class NumericKeyboardWidget extends GetWidget<NumericKeyboardLogic> {
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
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 0, keyEnabled: controller.screenDigitEnabled[0], controller: controller,)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 1, keyEnabled: controller.screenDigitEnabled[1], controller: controller,)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 2, keyEnabled: controller.screenDigitEnabled[2], controller: controller,)),
                    Expanded(flex: 25, child: ScreenDigit(keyIndex: 3, keyEnabled: controller.screenDigitEnabled[3], controller: controller,)),
                  ],
                ),
              ),
              Expanded(flex: 25,
                child: Row(
                  children: [
                    Expanded(flex: 25, child: NumberKey(keyNumber: 1, keyEnabled: controller.numberKeyEnabled[1], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 2, keyEnabled: controller.numberKeyEnabled[2], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 3, keyEnabled: controller.numberKeyEnabled[3], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 4, keyEnabled: controller.numberKeyEnabled[4], controller: controller,)),
                  ],
                ),
              ),
              Expanded(flex: 25,
                child: Row(
                  children: [
                    Expanded(flex: 25, child: NumberKey(keyNumber: 5, keyEnabled: controller.numberKeyEnabled[5], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 6, keyEnabled: controller.numberKeyEnabled[6], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 7, keyEnabled: controller.numberKeyEnabled[7], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 8, keyEnabled: controller.numberKeyEnabled[8], controller: controller,)),
                  ],
                ),
              ),
              Expanded(flex: 25,
                child: Row(
                  children: [
                    Expanded(flex: 25, child: NumberKey(keyNumber: 9, keyEnabled: controller.numberKeyEnabled[9], controller: controller,)),
                    Expanded(flex: 25, child: NumberKey(keyNumber: 0, keyEnabled: controller.numberKeyEnabled[0], controller: controller,)),
                    Expanded(flex: 25, child: BackSpaceKey(keyEnabled: controller.bsKeyEnabled.value, controller: controller,)),
                    Expanded(flex: 25, child: EnterKey(keyEnabled: controller.enterKeyEnabled.value,  controller: controller,)),
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

  final NumericKeyboardLogic controller;
  final int keyNumber;
  final bool keyEnabled;

  const NumberKey({Key? key,
    required this.keyNumber, required this.keyEnabled, required this.controller,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? controller.numberKeyTapped(keyNumber) : {},
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

  final NumericKeyboardLogic controller;

  final int keyIndex;
  final bool keyEnabled;
  const ScreenDigit({Key? key,
    required this.keyIndex, required this.keyEnabled, required this.controller,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Center(
          child: Text(
            controller.screenDigitNumbers[keyIndex].toString(),
            style: keyEnabled ? screenDigitOnStyle : screenDigitOffStyle,
          ),
        ),
    );
  }
}


class EnterKey extends StatelessWidget {

  final NumericKeyboardLogic controller;
  final bool keyEnabled;

  const EnterKey({Key? key, required this.keyEnabled, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? controller.enterKeyTapped() : {},
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

  final NumericKeyboardLogic controller;
  final bool keyEnabled;

  const BackSpaceKey({Key? key, required this.keyEnabled, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => keyEnabled ? controller.bsKeyTapped() : {},
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

import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/slider_switch_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../shared/constants.dart';

class SliderSwitch extends StatelessWidget {
  SliderSwitch({Key? key,}) : super(key: key);

  final SliderSwitchController controller = Get.put(SliderSwitchController());

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            key: controller.sliderTrackKey,
            child: appController.backPanelOn
                ? Image.asset('assets/images/slider_back.png')
                : Image.asset('assets/images/slider_back.png'),
          ),
          Obx(() {
            return AnimatedPositioned(
              left: controller.sliderThumbX.value,
              top: 0,
              duration: Duration(
                  milliseconds: controller.sliderDuration),
              // onEnd: () => controller.sliderDuration = 5,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) =>
                    controller.onSliderDragging(details),
                onHorizontalDragEnd: (details) =>
                    controller.onSliderDragEnd(details),
                onHorizontalDragStart: (details) =>
                    controller.onSliderDragStart(details),
                child: Container(
                  key: controller.sliderThumbKey,
                  child: appController.backPanelOn
                      ? Image.asset(
                      'assets/images/slider_thumb_on.png')
                      : Image.asset(
                      'assets/images/slider_thumb_off.png'),
                ),
              ),
            );
          })
        ]
    );
  }
}

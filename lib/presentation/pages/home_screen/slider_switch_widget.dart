import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/slider_switch_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
            child: SizedBox(width: Get.width*0.36,
                child: Image.asset('assets/images/slider_track.png', fit: BoxFit.fitHeight,)
            ),
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
                    child: SizedBox(width: Get.width*0.18,
                      child: Image.asset(
                        appController.drawerSlideValue == 0
                            ? 'assets/images/slider_open.png' : 'assets/images/slider_close.png',
                        fit: BoxFit.fitWidth,
                      ),
                    )
                ),
              ),
            );
          })
        ]
    );
  }
}

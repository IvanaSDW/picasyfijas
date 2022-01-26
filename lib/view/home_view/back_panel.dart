import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/back_panel_menu.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackPanelWidget extends StatelessWidget {
  const BackPanelWidget({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: Get.width,
        height: Get.height,
        color: originalColors.backPanelColor,
        child: Stack(
          children: [
            Container(
              width: controller.panelWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  left: 8.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: Column(
                children: [
                  Expanded(flex: 16,
                    child: Get.locale.toString().substring(0, 2) == 'es'
                        ? controller.backPanelOn
                        ? Image.asset('assets/images/logo_spanish_on.png',
                      width: controller.panelWidth * 0.9,)
                        : Image.asset('assets/images/logo_spanish_off.png',
                      width: controller.panelWidth * 0.9,)
                        : controller.backPanelOn
                        ? Image.asset('assets/images/logo_english_on.png',
                      width: controller.panelWidth * 0.9,)
                        : Image.asset('assets/images/logo_english_off.png',
                      width: controller.panelWidth * 0.9,),
                  ),
                  Expanded(flex: 70,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/panel_frame.png',),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackPanelMenu(controller: controller,),
                          Row(
                            children: [
                              Expanded(flex: 74,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/images/volume_groove.png'),
                                      controller.backPanelOn
                                          ? controller.isMuted
                                          ? Image.asset(
                                          'assets/images/volume_tip_on_sound_off.png')
                                          : Image.asset(
                                          'assets/images/volume_tip_on_sound_on.png')
                                          : Image.asset(
                                          'assets/images/volume_tip_off.png')
                                    ]
                                ),
                              ),
                              Expanded(flex: 3, child: Container(),),
                              Expanded(flex: 23,
                                child: InkWell(
                                  onTap: () => controller.toggleMuteOnOff(),
                                  child: controller.backPanelOn
                                      ? controller.isMuted
                                      ? Image.asset(
                                      'assets/images/mute_button_on_sound_off.png')
                                      : Image.asset(
                                      'assets/images/mute_button_on_sound_on.png')
                                      : Image.asset(
                                      'assets/images/mute_button_off.png'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 14,
                    child: Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: controller.backPanelOn
                                    ? Image.asset(
                                  'assets/images/power_button_on.png',)
                                    : Image.asset(
                                  'assets/images/power_button_off.png',),
                                onTap: () => controller.togglePanelOnOff(),
                              ),
                              Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Offset positionSB = controller.getPosition(controller.sliderTrackKey);
                                        logger.i('Slider track: X = ${positionSB.dx}, Y = ${positionSB.dy}');
                                        Offset positionSF = controller.getPosition(controller.sliderThumbKey);
                                        logger.i('Slider Thumb: X = ${positionSF.dx}, Y = ${positionSF.dy}');
                                        Rect rect = controller.getRect(controller.sliderTrackKey);
                                        logger.i('Size is: X = ${rect.size}');
                                      },
                                      child: Container(
                                        key: controller.sliderTrackKey,
                                        child: Image.asset(
                                            'assets/images/slider_back.png'),
                                      ),
                                    ),
                                    AnimatedPositioned(
                                      left: controller.sliderThumbX.value,
                                      top: 0,
                                      duration: Duration(milliseconds: controller.sliderDuration),
                                      child: GestureDetector(
                                        // onTapDown: (details) => controller.refreshSliderRenderInfo(),
                                        onHorizontalDragUpdate: (details) => controller.onSliderDragging(details),
                                        onHorizontalDragEnd: (details) => controller.onSliderDragEnd(details),
                                        child: Container(
                                          key: controller.sliderThumbKey,
                                          child: controller.backPanelOn
                                              ? Image.asset(
                                              'assets/images/slider_front_on.png')
                                              : Image.asset(
                                              'assets/images/slider_front_off.png'),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ],
                          ),
                          controller.backPanelOn
                              ? Image.asset('assets/images/copyright_on.png',
                            width: controller.panelWidth * 0.8,)
                              : Image.asset('assets/images/copyright_off.png',
                            width: controller.panelWidth * 0.8,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/panel_logo_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/volume_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/theme.dart';
import 'back_panel_controller.dart';
import 'back_panel_menu.dart';

class BackPanelWidget extends StatelessWidget {
  BackPanelWidget({Key? key,}) : super(key: key);
  final BackPanelController controller = Get.put(BackPanelController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: originalColors.backPanelColor,
      child: Stack(
        children: [
          Obx(() {
            return Container(
              width: appController.panelWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  left: 8.0, right: 12.0, top: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 16, //logo
                    child: PanelLogoWidget()
                  ),
                  Expanded(flex: 62,
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
                          const BackPanelMenu(),
                          Row(
                            children: [
                              Expanded(flex: 74,
                                child: VolumeWidget(),
                              ),
                              Expanded(flex: 3, child: Container(),),
                              Expanded(flex: 23,
                                child: InkWell(
                                  onTap: () => controller.toggleMuteOnOff(),
                                  child: appController.backPanelOn
                                      ? appController.isMuted
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
                  Expanded(flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: appController.backPanelOn
                              ? Image.asset(
                            'assets/images/power_button_on.png',)
                              : Image.asset(
                            'assets/images/power_button_off.png',),
                          onTap: () => controller.togglePanelOnOff(),
                        ),
                        controller.sliderSwitch,
                      ],
                    ),
                  ),
                  Expanded(flex: 14,
                    child: Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          appController.backPanelOn
                              ? Image.asset('assets/images/copyright_on.png',
                            width: appController.panelWidth * 0.8,)
                              : Image.asset('assets/images/copyright_off.png',
                            width: appController.panelWidth * 0.8,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}


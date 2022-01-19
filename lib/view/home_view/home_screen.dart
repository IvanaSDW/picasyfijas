import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_data_display.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/quit_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/start_ttm_match_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/start_vs_mode_match_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/system_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class GuestHomePage extends StatelessWidget {
  final GuestHomeController controller = Get.put(GuestHomeController());

  GuestHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Material(
        color: originalColors.backgroundColor,
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    flex: 18,
                    child: PlayerDataDisplay(),
                  ),
                  const Divider(height: 20,),
                  Expanded(
                      flex: 54,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Center(
                            child: Image(
                              image: AssetImage(
                                  'assets/images/key_pad_home.png'),
                            ),
                          ),
                          Column(
                            children: [
                              Expanded(
                                  flex: 25,
                                  child: Container(
                                    height: 1,
                                  )),
                              Expanded(
                                flex: 20,
                                child: StartTimeTrialMatchButton(
                                  onTapAction: () =>
                                      controller.onTimeTrialModeTapped(),
                                ),
                              ),
                              Expanded(
                                  flex: 10,
                                  child: Container(
                                    height: 1,
                                  )),
                              Expanded(
                                flex: 20,
                                child: StartVsModeMatchButton(
                                  onTapAction: () =>
                                      controller
                                          .onVsModeTapped(
                                          authController.authState),
                                ),
                              ),
                              Expanded(
                                  flex: 25,
                                  child: Container(
                                    height: 1,
                                  )),
                            ],
                          )
                        ],
                      )),
                  Expanded(
                      flex: 13,
                      child: Center(
                        child: QuitButton(
                          onTapAction: () => controller.onQuitPressed(),
                        ),
                      )),
                  const Expanded(
                    flex: 15,
                    child: Hero(
                        tag: 'system_status', child: SystemStatusView()),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: appController.isBusy,
              child: const SpinKitChasingDots(color: Colors.white,),
            ),
          ],
        ),
      );
    });
  }
}

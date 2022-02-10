import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_data_display.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/front_panel_painter.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/start_ttm_match_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/start_vs_mode_match_button.dart';
import 'package:bulls_n_cows_reloaded/view/home_view/system_status_widget.dart';
import 'package:bulls_n_cows_reloaded/view/splash_view/matrix_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class FrontPanelWidget extends StatelessWidget {
  const FrontPanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: FrontPanelClipper(),
          child: PhysicalModel(
            clipBehavior: Clip.antiAlias,
            color: const Color(0xFF000000),
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: CustomPaint(
                painter: FrontPanelPainter(
                    width: 6.0
                ),
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(seconds: 2),
                    child: appController.backPanelOn
                        ? Column(
                      children: [
                        Expanded(
                          flex: 18,
                          child: PlayerDataDisplay(onAvatarTapped: () => {},),
                        ),
                        Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(70.0),
                              child: HomeKeysWidget(controller: controller),
                            )
                        ),
                        Expanded(
                            flex: 8,
                            child: Container()
                        ),
                        const Expanded(
                          flex: 14,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Hero(
                                tag: 'system_status',
                                child: SystemStatusView()),
                          ),
                        ),
                      ],
                    )
                        : MatrixEffect(),
                  );
                }),
              ),
            ),
          ),
        ),
        // Obx(() {
        //   return AnimatedSwitcher(
        //     duration: const Duration(seconds: 2),
        //     child: appController.backPanelOn
        //         ? Column(
        //       children: [
        //         Expanded(
        //           flex: 18,
        //           child: PlayerDataDisplay(onAvatarTapped: () => {},),
        //         ),
        //         Expanded(
        //             flex: 60,
        //             child: Padding(
        //               padding: const EdgeInsets.all(70.0),
        //               child: HomeKeysWidget(controller: controller),
        //             )
        //         ),
        //         Expanded(
        //             flex: 8,
        //             child: Container()
        //         ),
        //         const Expanded(
        //           flex: 14,
        //           child: Padding(
        //             padding: EdgeInsets.all(3.0),
        //             child: Hero(
        //                 tag: 'system_status', child: SystemStatusView()),
        //           ),
        //         ),
        //       ],
        //     )
        //         : MatrixEffect(),
        //   );
        // }),
      ],
    );
  }
}

class HomeKeysWidget extends StatelessWidget {
  const HomeKeysWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/key_pad_home.png',),
              fit: BoxFit.contain
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StartTimeTrialMatchButton(
              onTapAction: () =>
                  controller.onTimeTrialModeTapped(),
            ),
            StartVsModeMatchButton(
              onTapAction: () =>
                  controller
                      .onVsModeTapped(
                      authController.authState),
            ),
          ],
        )
    );
  }
}


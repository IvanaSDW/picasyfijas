import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/player_data_display/player_data_display.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/system_status_widget.dart';
import 'package:bulls_n_cows_reloaded/shared/widgets/matrix_effect/matrix_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_screen/front_panel_painter.dart';
import '../home_screen/quit_button.dart';
import 'home_controller.dart';
import 'home_keys_widget.dart';

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
                        Expanded(flex: 18,
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
                        : const QuitWidget(),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuitWidget extends StatelessWidget {
  const QuitWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MatrixEffect(),
        Center(
            child: QuitButton(
                onTapAction: () => appController.quitApp()
            )
        ),
      ],
    );
  }
}

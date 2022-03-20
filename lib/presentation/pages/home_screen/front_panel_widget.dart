
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/home_screen/ad_area_painter.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/player_data_display/player_data_display.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/system_status_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../widgets/matrix_effect/matrix_effect_controller.dart';
import 'front_panel_clipper.dart';
import 'front_panel_painter.dart';
import 'quit_button.dart';
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
            elevation: 10,
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
                  return Column(
                    children: [
                      Expanded(flex: 18,
                        child: PlayerDataDisplay(onAvatarTapped: () => controller.onAvatarTapped(), isP1: false,),
                      ),
                      Expanded(
                          flex: 51,
                          child: Padding(
                            padding: const EdgeInsets.all(70.0),
                            child: AbsorbPointer(
                              absorbing: appController.isBusy,
                              child: HomeKeysWidget(controller: controller),
                            ),
                          )
                      ),
                      const Expanded(
                          flex: 10,
                          child: Hero(
                            tag: 'system_status',
                            child: Padding(
                              padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0, bottom: 4.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  child: SystemStatusView()
                              ),
                            ),
                          )
                      ),
                      Expanded(
                        flex: 23,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 6.0, bottom: 4.0),
                          child: Stack(alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                height: Get.height*0.3, width: Get.width,
                                child: CustomPaint(
                                  painter: AddAreaPainter(strokeWidth: 3.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 33,
                                        child: Row(
                                          children: [
                                            Expanded(flex: 59, child: Container()),
                                            Expanded(flex: 41,
                                              child: Center(
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const AutoSizeText(
                                                      'ADS',
                                                      style: TextStyle(fontSize: 24, fontFamily: 'Digital',),
                                                    ),
                                                    Container(width: 10,),
                                                    Image.asset('assets/images/ad_speaker.png'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(flex: 67,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: controller.isBottomBannerAdLoaded
                                              ? AdWidget(ad: controller.bottomBannerAd)
                                              : const SizedBox.shrink(),
                                        )
                                    ),
                                  ],
                                ),
                              )
                              // ? const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ],
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
        MatrixEffect(controller: Get.put(MatrixEffectController(), tag: 'front_panel')),
        Center(
            child: QuitButton(
                onTapAction: () => appController.quitApp()
            )
        ),
      ],
    );
  }
}

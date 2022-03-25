import 'dart:ui';
import 'package:bulls_n_cows_reloaded/presentation/pages/look_for_opponent_screen/find_opponent_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/look_for_opponent_screen/radar_widget.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../widgets/matrix_effect/matrix_effect_controller.dart';

class FindOpponentView extends StatelessWidget {
  FindOpponentView({Key? key}) : super(key: key);
  final FindOpponentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'looking_for_opponent'.tr,
            style: defaultTextStyle,
          ),
          const SizedBox(height: 20,),
          Stack(
            alignment: Alignment.center,
            children: [
              Hero(tag: 'home_pad',
                child: Container(
                    height: Get.height*0.45,
                    width: Get.height*0.35,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        image: DecorationImage(
                            image: AssetImage('assets/images/key_pad_home.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Obx(() {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 700),
                        child: controller.matrixVisible
                            ? ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                            child: MatrixEffect(controller: Get.put(MatrixEffectController(speedMillis: 100), tag: 'find_opponent',))
                        )
                        : const SizedBox.shrink(),
                      );
                    })
                ),
              ),
              SizedBox(
                height: Get.height*0.45,
                width: Get.height*0.35,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0
                      ),
                      child: Image.asset('assets/images/world_map.png',
                        fit: BoxFit.contain,)
                  ),
                ),
              ),
              SizedBox(
                  height: Get.height*0.33,
                  width: Get.height*0.33,
                  child: RadarWidget()),
            ],
          ),
          const SizedBox(height: 20,),
          StreamBuilder(
              stream: firestoreService.appGeneralInfo(),
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? SpinKitThreeBounce(color: originalColors.accentColor2,)
                    : Column(
                  children: [
                    Text(
                      (snapshot.data![appGlobalsVersusGamesCountFN]*2.5).toStringAsFixed(0) + '_players'.tr,
                      style: defaultTextStyle,
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      snapshot.data![appGlobalsVersusGamesCountFN].toString() + '_games'.tr,
                      style: defaultTextStyle,
                    ),
                  ],
                );
              }
          ),
          const SizedBox(height: 40,),
          InkWell(
            onTap: () => controller.onChallengeCanceled(),
            child: Text(
              'x '+'cancel'.tr,
              style: const TextStyle(color: Colors.amber, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

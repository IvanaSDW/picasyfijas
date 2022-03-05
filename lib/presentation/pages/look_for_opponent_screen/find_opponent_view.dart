import 'dart:ui';
import 'package:bulls_n_cows_reloaded/presentation/pages/look_for_opponent_screen/find_opponent_controller.dart';
import 'package:bulls_n_cows_reloaded/shared/text_styles.dart';
import 'package:bulls_n_cows_reloaded/presentation/widgets/matrix_effect/matrix_effect.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/look_for_opponent_screen/radar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              'Looking for opponent',
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
                  // height: Get.height*0.5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                        child: MatrixEffect()
                    )
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
          Text(
            '1250 players',
            style: defaultTextStyle,
          ),
          const SizedBox(height: 6,),
          Text(
            '335 games',
            style: defaultTextStyle,
          ),
          const SizedBox(height: 40,),
          InkWell(
            onTap: () => controller.onChallengeCanceled(),
            child: Text(
              'X Cancel',
              style: textButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}

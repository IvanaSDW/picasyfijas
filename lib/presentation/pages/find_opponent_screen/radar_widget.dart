import 'package:bulls_n_cows_reloaded/presentation/pages/find_opponent_screen/radar_controller.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/find_opponent_screen/radar_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RadarWidget extends StatelessWidget {
  RadarWidget({Key? key}) : super(key: key);
  final RadarController controller = Get.put(RadarController());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller.animation,
        builder: (context, child) {
          return CustomPaint(
            painter: RadarPainter(controller.animation.value),
          );
        }
    );
  }
}
